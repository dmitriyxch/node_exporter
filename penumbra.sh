sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
# press 1 
source ~/.cargo/env
apt install git

git clone https://github.com/penumbra-zone/penumbra
cd penumbra && git checkout 007-herse && cargo update
cargo build --release --bin pcli
# Создать новый кошелек 
cargo run --quiet --release --bin pcli wallet generate 
# Экспортировать кошелек 
cargo run --quiet --release --bin pcli wallet export
export RUST_LOG=info

cargo run --quiet --release --bin pcli sync
cargo run --quiet --release --bin pcli addr list
cargo run --quiet --release --bin pcli stake list-validators
