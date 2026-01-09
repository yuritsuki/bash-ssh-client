# Setup & Usage

## Prerequisites

Make sure the following tools are installed on your system:

- **yq** — for parsing YAML files
- **sshpass** — for non-interactive SSH authentication

### Install on Debian / Ubuntu
```bash
sudo apt update
sudo apt install -y yq sshpass
```
## Configuration 
See hosts.yml.example

## Usage 
1. Make the script executable:
```bash
chmod +x ./s.sh
```
2.	Run the script and specify the host name defined in hosts.yml:
```bash
./s.sh <host>
```
## License
MIT
