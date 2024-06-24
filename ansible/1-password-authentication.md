The error "No identities found" when running `ssh-copy-id` indicates that the SSH agent does not have any SSH keys loaded, or the keys are not stored in the default location (`~/.ssh/id_rsa.pub`).

Here's a step-by-step guide to resolve this:

1. **Check for Existing SSH Keys:**
   Ensure you have an existing SSH key pair. Check the `~/.ssh` directory:
   ```bash
   ls ~/.ssh
   ```

   Look for files named `id_rsa` (private key) and `id_rsa.pub` (public key). If they exist, proceed to step 3. If not, go to step 2.

2. **Generate a New SSH Key Pair:**
   If you don't have an SSH key pair, generate one using:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   Follow the prompts to save the key to the default location (`~/.ssh/id_rsa`) and optionally add a passphrase.

3. **Load the SSH Key into the SSH Agent:**
   Ensure the SSH key is loaded into the SSH agent. Start the SSH agent if it is not already running:
   ```bash
   eval "$(ssh-agent -s)"
   ```

   Add your SSH key to the agent:
   ```bash
   ssh-add ~/.ssh/id_rsa
   ```

4. **Copy the SSH Key to the Remote Server:**
   Now you can copy your SSH key to the remote server:
   ```bash
   ssh-copy-id ubuntu@54.237.154.120
   ```

If you encounter any issues, make sure the SSH agent is running and has your key loaded by checking the output of:
```bash
ssh-add -l
```
This command lists the keys currently managed by the SSH agent.
