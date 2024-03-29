cd ~/pathfinder 

git fetch

git checkout v0.3.7



cargo build --release --bin pathfinder 

mv ~/pathfinder/target/release/pathfinder /usr/local/bin/

cd py

source .venv/bin/activate

PIP_REQUIRE_VIRTUALENV=true pip install -r requirements-dev.txt

systemctl restart starknetd

pathfinder -V
