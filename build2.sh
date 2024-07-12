#/bash/sh

export VERSION=0.26.10
export GOPROXY=direct

type -p go1 || { 
    echo "[ERROR] GO required, but not found"
    exit
}

set -x

cd "$(dirname "$0")"
cd "$(realpath "$PWD")"

type -p openssl && \
openssl req \
-subj "/C=CN/ST=$RANDOM/L=$RANDOM/O=$RANDOM/OU=$RANDOM/CN=$RANDOM/emailAddress=$RANDOM@$RANDOM.com" \
-new -x509 -days 3650 -nodes \
-out conf/server.pem -keyout conf/server.key


# ============== npc ==============

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/npc/npc.go
tar -czvf linux_amd64_client.tar.gz npc conf/npc.conf conf/multi_account.conf

CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/npc/npc.go
tar -czvf linux_arm_v7_client.tar.gz npc conf/npc.conf conf/multi_account.conf

CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/npc/npc.go
tar -czvf linux_arm64_client.tar.gz npc conf/npc.conf conf/multi_account.conf

CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/npc/npc.go
tar -czvf windows_amd64_client.tar.gz npc.exe conf/npc.conf conf/multi_account.conf

CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/npc/npc.go
tar -czvf darwin_amd64_client.tar.gz npc conf/npc.conf conf/multi_account.conf

CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/npc/npc.go
tar -czvf darwin_arm64_client.tar.gz npc conf/npc.conf conf/multi_account.conf



# ============== nps ==============

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/nps/nps.go
tar -czvf linux_amd64_server.tar.gz conf/nps.conf conf/tasks.json conf/clients.json conf/hosts.json conf/server.key conf/server.pem web/views web/static nps

CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/nps/nps.go
tar -czvf linux_arm_v7_server.tar.gz conf/nps.conf conf/tasks.json conf/clients.json conf/hosts.json conf/server.key conf/server.pem web/views web/static nps

CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/nps/nps.go
tar -czvf linux_arm64_server.tar.gz conf/nps.conf conf/tasks.json conf/clients.json conf/hosts.json conf/server.key conf/server.pem web/views web/static nps

CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/nps/nps.go
tar -czvf darwin_amd64_server.tar.gz conf/nps.conf conf/tasks.json conf/clients.json conf/hosts.json conf/server.key conf/server.pem web/views web/static nps

CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/nps/nps.go
tar -czvf darwin_arm64_server.tar.gz conf/nps.conf conf/tasks.json conf/clients.json conf/hosts.json conf/server.key conf/server.pem web/views web/static nps

CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -extldflags -static -extldflags -static" ./cmd/nps/nps.go
tar -czvf windows_amd64_server.tar.gz conf/nps.conf conf/tasks.json conf/clients.json conf/hosts.json conf/server.key conf/server.pem web/views web/static nps.exe


exit
