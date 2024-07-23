To save your GitHub token as an environment variable in Ubuntu, you can follow these steps:

1. **Open Terminal:**
   Press `Ctrl+Alt+T` to open the terminal.

2. **Open Your Shell Profile:**
   Open the shell profile file in a text editor. The shell profile file depends on the shell you are using. For `bash`, it's `.bashrc`, and for `zsh`, it's `.zshrc`.

   For `bash`:
   ```sh
   nano ~/.bashrc
   ```

   For `zsh`:
   ```sh
   nano ~/.zshrc
   ```

3. **Add the Environment Variable:**
   Add the following line to the end of the file, replacing `YOUR_GITHUB_TOKEN` with your actual GitHub token:
   ```sh
   export GITHUB_TOKEN=YOUR_GITHUB_TOKEN
   ```

4. **Save and Close the File:**
   Press `Ctrl+O` to save the file and `Ctrl+X` to exit the text editor.

5. **Reload the Shell Profile:**
   Apply the changes by reloading your shell profile:
   ```sh
   source ~/.bashrc  # for bash
   source ~/.zshrc   # for zsh
   ```

Now, your GitHub token will be available as an environment variable named `GITHUB_TOKEN` in your terminal sessions. You can verify this by running:
```sh
echo $GITHUB_TOKEN
```
