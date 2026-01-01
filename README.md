# Auto PublicIP for Minecraft


This repository contains a simple bash script to enhance the security of a self-hosted Minecraft server on a Linux machine using the Uncomplicated Firewall (UFW).

The script automates the process of allowing connections to the Minecraft port (25565) exclusively from your current public IP address. This is perfect for server admins with dynamic IP addresses who want to grant access to themselves or friends without exposing the server port to the entire internet.

## How It Works

When you run the script, it performs the following steps:
1.  **Detects IP:** It automatically fetches your current public IP address.
2.  **Prompts for Confirmation:** It clearly states what it will do and requires you to confirm before proceeding.
3.  **Resets Firewall:** It **deletes all existing UFW rules**.
4.  **Applies New Rules:** It adds new firewall rules to allow both TCP and UDP traffic on port `25565` originating *only* from your detected public IP.
5.  **Re-enables UFW:** It ensures the firewall is active with the new, secure ruleset.

**Important:** The script intentionally does not change your default UFW policies (e.g., `default deny incoming`). It only manages the numbered rules, preserving your underlying security posture.

## Prerequisites

*   A Linux system with `bash`.
*   [Uncomplicated Firewall (UFW)](https://wiki.ubuntu.com/ufw) installed and enabled.
*   `curl` installed to fetch the public IP.
*   `sudo` privileges.

## Usage

1.  Clone this repository or download the `bash.sh` script.
    ```sh
    git clone https://github.com/siraprem/AutoIP-for-Minecraft.git
    cd AutoIP-for-Minecraft
    ```

2.  Make the script executable:
    ```sh
    chmod +x bash.sh
    ```

3.  Run the script with `sudo`:
    ```sh
    sudo ./bash.sh
    ```

4.  The script will display your current IP and ask for confirmation. The prompts are in Portuguese; you must type `SIM` and press Enter to proceed.

    Once confirmed, it will apply the new rules and display the updated UFW status.

Whenever your public IP address changes, simply run the script again to update the firewall.

### SSH Access

The script includes a commented-out line to optionally allow SSH access (port 22) from your IP address. If you manage your server remotely, it is highly recommended to uncomment this line in the script to prevent locking yourself out.

```bash
# Optional: allow SSH from the same IP (uncomment if you need it)
# sudo ufw allow from "$PUBLIC_IP" to any port 22 proto tcp comment "Temporary SSH"
```

## Warning

This script is destructive as it will **reset your UFW configuration**, deleting all existing numbered rules. Review the script and ensure you understand its function before executing it. It is designed to be the primary tool for managing access rules on a dedicated or simple-purpose server.