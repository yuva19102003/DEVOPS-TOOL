
# Git Commmands

---

### Setting Up a Repository

1. **Initialize a new Git repository:**
   ```sh
   git init
   ```

2. **Clone an existing repository:**
   ```sh
   git clone https://github.com/user/repo.git
   ```

### Basic Workflow

3. **Check the status of your repository:**
   ```sh
   git status
   ```

4. **Add changes to the staging area:**
   ```sh
   git add filename
   # or add all changes
   git add .
   ```

5. **Commit changes:**
   ```sh
   git commit -m "Commit message"
   ```

### Branching and Merging

6. **Create a new branch:**
   ```sh
   git branch new-branch
   ```

7. **Switch to a different branch:**
   ```sh
   git checkout new-branch
   ```

8. **Create and switch to a new branch:**
   ```sh
   git checkout -b new-branch
   ```

9. **Merge a branch into the current branch:**
   ```sh
   git merge branch-to-merge
   ```

### Remote Repositories

10. **Add a remote repository:**
    ```sh
    git remote add origin https://github.com/user/repo.git
    ```

11. **Set the remote URL with a token (as per your example):**
    ```sh
    git remote set-url origin https://$GITHUB_TOKEN@github.com/yuva19102003/portfolio.git
    ```

12. **Push changes to a remote repository:**
    ```sh
    git push origin main
    ```

13. **Pull changes from a remote repository:**
    ```sh
    git pull origin main
    ```

14. **Fetch changes from a remote repository (without merging):**
    ```sh
    git fetch origin
    ```

### Viewing History

15. **View commit history:**
    ```sh
    git log
    ```

16. **View a summarized commit history (one line per commit):**
    ```sh
    git log --oneline
    ```

### Undoing Changes

17. **Unstage a file:**
    ```sh
    git reset HEAD filename
    ```

18. **Revert changes in a file to the last committed state:**
    ```sh
    git checkout -- filename
    ```

19. **Revert a specific commit:**
    ```sh
    git revert commit-hash
    ```

### Stashing Changes

20. **Stash changes:**
    ```sh
    git stash
    ```

21. **List stashed changes:**
    ```sh
    git stash list
    ```

22. **Apply stashed changes:**
    ```sh
    git stash apply
    ```

### Working with Tags

23. **Create a new tag:**
    ```sh
    git tag -a v1.0 -m "Version 1.0"
    ```

24. **Push tags to the remote repository:**
    ```sh
    git push origin --tags
    ```

### Example Workflow

Let's go through a typical workflow using some of these commands:

1. **Clone a repository:**
   ```sh
   git clone https://github.com/yuva19102003/portfolio.git
   cd portfolio
   ```

2. **Create a new branch:**
   ```sh
   git checkout -b new-feature
   ```

3. **Make changes to files and add them to the staging area:**
   ```sh
   git add .
   ```

4. **Commit your changes:**
   ```sh
   git commit -m "Add new feature"
   ```

5. **Push your changes to the remote repository:**
   ```sh
   git push origin new-feature
   ```

6. **Switch back to the main branch:**
   ```sh
   git checkout main
   ```

7. **Merge the new feature branch into the main branch:**
   ```sh
   git merge new-feature
   ```

8. **Push the updated main branch to the remote repository:**
   ```sh
   git push origin main
   ```

This workflow demonstrates how to clone a repository, create and switch branches, make and commit changes, and push those changes to a remote repository.
