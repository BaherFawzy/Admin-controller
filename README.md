# Admin-Controller
# it is a mini program to help system admins who use Linux in general and specially beginners. 

# User-Admin-TUI
A comprehensive Text-based User Interface (TUI) for managing user accounts and groups on Linux systems. This project enhances system administration by providing an interactive, user-friendly interface for managing common administrative tasks.
## Features

### User Management
- *Add User:* 
  - Quickly add new users to the system with an interactive prompt.
  - Checks if the username already exists to avoid conflicts.
- *Modify User:*
  - Update user details such as home directory, UID, primary group, and more.
  - Features include:
    - *Disable User:*
          - Lock user accounts to prevent login.
    - *Enable User:*
          - Unlock user accounts, restoring login capabilities.
    - *Change Password:*
          - Change the password of a user securely.
    - *Change Home Directory:* Specify a new home directory for an existing user.
    - *Set Primary Group:* Change the primary group of a user.
    - *Lock/Unlock Account:* Temporarily disable or re-enable user accounts.
    - *Change UID:* Assign a new User ID to an existing account.
    - *Append Groups:* Add the user to additional groups without affecting current memberships.
  - Automatically checks if the user exists before attempting any modifications.
- *Delete User:*
  - Safely remove users from the system with confirmation prompts to prevent accidental deletions.
  - Validates user existence before proceeding with deletion.

### Group Management
- *Add Group:*
  - Create new groups with ease, ensuring group names are unique.
- *Delete Group:*
  - Remove groups from the system with confirmation prompts.
  - Validates group existence before proceeding with deletion.
- *Modify Group:*
  - change group name 
  - append user to group
  - remove user from group 

### System Information
- *List Users:*
  - Display a list of all created users currently on the system.
- *List Groups:*
  - Display a list of all created groups currently on the system.
- *About:*
  - Provides information about the program, its purpose, and how to use it.
```

# Made BY Baher Fawzy with the help of Eng.Romany Nageh under Supported by Information Technology Institute-ITI
