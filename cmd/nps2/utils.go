package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"encoding/base64"
	"io"
	"os"
)

func GetExecutable() string {
	ex, err := os.Executable()
	if err != nil {
		return ""
	}
	return ex
}

// pos 为正数表示从文件头开始,负数表示从末尾开始
func FileRead(file1 string, pos int64, length uint64) ([]byte, error) {
	file, err := os.Open(file1)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	file.Seek(0, io.SeekEnd)                      // 将文件指针移动到文件末尾
	fileSize, err := file.Seek(0, io.SeekCurrent) // 获取文件指针的当前位置（文件大小）
	if err != nil {
		return nil, err
	}

	bufferSize := int64(length)
	buffer := make([]byte, bufferSize)
	readPos := int64(0)
	if pos > 0 {
		readPos = pos
	} else if pos < 0 {
		readPos = fileSize + pos
	}

	_, err = file.ReadAt(buffer, readPos)
	if err != nil {
		return nil, err
	}

	return buffer, nil
}

func pKCS5Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

func removePadding(pt []byte) []byte {
	padLength := int(pt[len(pt)-1])
	return pt[:len(pt)-padLength]
}

// 解密命令行参数
func DecryptCMD(f4 string) (string, error) {
	a1, err := base64.StdEncoding.DecodeString(f4)
	if err != nil {
		return "", err
	}

	// echo key|md5
	b1, err := aes.NewCipher([]byte("146c07ef2479cedcd54c7c2af5cf3a80"))
	if err != nil {
		return "", err
	}

	// echo iv|md5
	b2 := cipher.NewCBCDecrypter(b1, []byte("2e4af5373f018c22856e7c92b9889a05")[0:b1.BlockSize()])

	b3 := make([]byte, len(a1))
	b2.CryptBlocks(b3, a1)

	b3 = removePadding(b3)

	return string(b3), nil
}

// 加密命令行参数
func EncryptCMD(f4 string) (string, error) {

	// echo key|md5
	b1, err := aes.NewCipher([]byte("146c07ef2479cedcd54c7c2af5cf3a80"))
	if err != nil {
		return "", err
	}

	// echo iv|md5
	b2 := cipher.NewCBCEncrypter(b1, []byte("2e4af5373f018c22856e7c92b9889a05")[0:b1.BlockSize()])

	content := pKCS5Padding([]byte(f4), b2.BlockSize())
	b3 := make([]byte, len(content))

	b2.CryptBlocks(b3, content)

	a1 := base64.StdEncoding.EncodeToString(b3)
	return a1, nil
}
