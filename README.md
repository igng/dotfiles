# dotfiles

Collection of dotfiles

## Installation

```bash
stow <package>
# stow nvim
```

## How to use devcontainer

### Start the SSH agent
```bash
eval "$(ssh-agent -s)"  # Agent pid xxxx
```

### Add SSH key (ssh-add <path to private key>)
```bash
ssh-add ~/.ssh/id_ed25519   # Identity added: <path to private key>
```

### Verify it worked
```bash
ssh-add -l
echo "$SSH_AUTH_SOCK"   # <path to ssh socket> (e.g., /tmp/ssh-GIsuSJQmoXOQ/agent.3072)
```

### Create the container
```bash
devcontainer up --docker-path podman
```

### Execute the container and start an interactive shell
```bash
devcontainer exec --docker-path podman /bin/bash -i
```
