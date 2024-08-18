#!/bin/bash

# Set default whiptail colors
export NEWT_COLORS='
  root=green,black
  checkbox=red,black
  button=white,black
  title=blue,black
  roottext=white,black
'

# Function to show a success message
function success_message() {
    whiptail --msgbox "$1" 8 45 --title "Success"
}

# Function to show an error message
function error_message() {
    whiptail --msgbox "$1" 8 45 --title "Error"
}

# Function to check if a command succeeded
function check_command_success() {
    if [ $? -eq 0 ]; then
        success_message "$1"
    else
        error_message "$2"
    fi
}

# Function to add a user
function add_user() {
    USERNAME=$(whiptail --inputbox "Enter username:" 8 39 --title "Add User" 3>&2 2>&1 1>&3)
    sudo adduser $USERNAME
    check_command_success "User $USERNAME added successfully" "Failed to add user $USERNAME"
}

function modify_user() {
    USERNAME=$(whiptail --inputbox "Enter username to modify:" 8 39 --title "Modify User" 3>&2 2>&1 1>&3)
    if id "$USERNAME" &>/dev/null; then
        MODIFY_OPTION=$(whiptail --title "Modify User" --menu "Choose an option" 20 60 7 \
        "1" "Change Username" \
        "2" "Change User ID" \
        "3" "Change User Information (GECOS)" \
        "4" "Change Home Directory" \
        "5" "Change Login Shell" \
        "6" "Change Primary Group" \
        "7" "Add User to Secondary Group" 3>&2 2>&1 1>&3)

        case $MODIFY_OPTION in
            1)
                NEW_USERNAME=$(whiptail --inputbox "Enter new username:" 8 39 --title "Change Username" 3>&2 2>&1 1>&3)
                sudo usermod -l $NEW_USERNAME $USERNAME
                check_command_success "Username changed to $NEW_USERNAME" "Failed to change username"
                ;;
            2)
                NEW_UID=$(whiptail --inputbox "Enter new User ID:" 8 39 --title "Change User ID" 3>&2 2>&1 1>&3)
                sudo usermod -u $NEW_UID $USERNAME
                check_command_success "User ID changed to $NEW_UID" "Failed to change User ID"
                ;;
            3)
                NEW_GECOS=$(whiptail --inputbox "Enter new GECOS information:" 8 39 --title "Change GECOS" 3>&2 2>&1 1>&3)
                sudo usermod -c "$NEW_GECOS" $USERNAME
                check_command_success "GECOS information updated" "Failed to update GECOS"
                ;;
            4)
                NEW_HOME=$(whiptail --inputbox "Enter new Home Directory:" 8 39 --title "Change Home Directory" 3>&2 2>&1 1>&3)
                sudo usermod -d $NEW_HOME $USERNAME
                check_command_success "Home directory changed to $NEW_HOME" "Failed to change home directory"
                ;;
            5)
                NEW_SHELL=$(whiptail --inputbox "Enter new Login Shell:" 8 39 --title "Change Login Shell" 3>&2 2>&1 1>&3)
                sudo usermod -s $NEW_SHELL $USERNAME
                check_command_success "Login shell changed to $NEW_SHELL" "Failed to change login shell"
                ;;
            6)
                NEW_GROUP=$(whiptail --inputbox "Enter new Primary Group:" 8 39 --title "Change Primary Group" 3>&2 2>&1 1>&3)
                sudo usermod -g $NEW_GROUP $USERNAME
                check_command_success "Primary group changed to $NEW_GROUP" "Failed to change primary group"
                ;;
            7)
                SECONDARY_GROUP=$(whiptail --inputbox "Enter Secondary Group to add user to:" 8 39 --title "Add User to Secondary Group" 3>&2 2>&1 1>&3)
                sudo usermod -aG $SECONDARY_GROUP $USERNAME
                check_command_success "User $USERNAME added to secondary group $SECONDARY_GROUP" "Failed to add user to secondary group"
                ;;
        esac
    else
        error_message "User $USERNAME does not exist"
    fi
}

# Function to delete a user
function delete_user() {
    USERNAME=$(whiptail --inputbox "Enter username to delete:" 8 39 --title "Delete User" 3>&2 2>&1 1>&3)
    sudo userdel -r $USERNAME
    check_command_success "User $USERNAME deleted successfully" "Failed to delete user $USERNAME"
}

# Function to list users
function list_users() {  
    USERS=$(cut -d: -f1 /etc/passwd)
    whiptail --msgbox "List Users:\n$USERS" 0 0
}

# Function to enable a user
function enable_user() {
    USERNAME=$(whiptail --inputbox "Enter username to enable:" 8 39 --title "Enable User" 3>&2 2>&1 1>&3)
    sudo usermod -U $USERNAME
    check_command_success "User $USERNAME enabled" "Failed to enable user $USERNAME"
}

# Function to disable a user
function disable_user() {
    USERNAME=$(whiptail --inputbox "Enter username to disable:" 8 39 --title "Disable User" 3>&2 2>&1 1>&3)
    sudo usermod -L $USERNAME
    check_command_success "User $USERNAME disabled" "Failed to disable user $USERNAME"
}

# Function to change password
function change_password() {
    USERNAME=$(whiptail --inputbox "Enter username to change password:" 8 39 --title "Change Password" 3>&2 2>&1 1>&3)
    sudo passwd $USERNAME
    check_command_success "Password for $USERNAME changed successfully" "Failed to change password for $USERNAME"
}

# Function to add a group
function add_group() {
    GROUPNAME=$(whiptail --inputbox "Enter group name to add:" 8 39 --title "Add Group" 3>&2 2>&1 1>&3)
    sudo groupadd $GROUPNAME
    check_command_success "Group $GROUPNAME added successfully" "Failed to add group $GROUPNAME"
}

# Function to modify an existing group
function modify_group() {
    GROUPNAME=$(whiptail --inputbox "Enter group name to modify:" 8 39 --title "Modify Group" 3>&2 2>&1 1>&3)
    if getent group $GROUPNAME &>/dev/null; then
        MODIFY_GROUP_OPTION=$(whiptail --title "Modify Group" --menu "Choose an option" 20 60 3 \
        "1" "Change Group Name" \
        "2" "Add User to Group" \
        "3" "Remove User from Group" 3>&2 2>&1 1>&3)

        case $MODIFY_GROUP_OPTION in
            1)
                NEW_GROUPNAME=$(whiptail --inputbox "Enter new group name:" 8 39 --title "Change Group Name" 3>&2 2>&1 1>&3)
                sudo groupmod -n $NEW_GROUPNAME $GROUPNAME
                check_command_success "Group name changed to $NEW_GROUPNAME" "Failed to change group name"
                ;;
            2)
                USERNAME=$(whiptail --inputbox "Enter username to add to group:" 8 39 --title "Add User to Group" 3>&2 2>&1 1>&3)
                sudo usermod -aG $GROUPNAME $USERNAME
                check_command_success "User $USERNAME added to group $GROUPNAME" "Failed to add user to group"
                ;;
            3)
                USERNAME=$(whiptail --inputbox "Enter username to remove from group:" 8 39 --title "Remove User from Group" 3>&2 2>&1 1>&3)
                sudo gpasswd -d $USERNAME $GROUPNAME
                check_command_success "User $USERNAME removed from group $GROUPNAME" "Failed to remove user from group"
                ;;
        esac
    else
        error_message "Group $GROUPNAME does not exist"
    fi
}

# Function to delete a group
function delete_group() {
    GROUPNAME=$(whiptail --inputbox "Enter group name to delete:" 8 39 --title "Delete Group" 3>&2 2>&1 1>&3)
    sudo groupdel $GROUPNAME
    check_command_success "Group $GROUPNAME deleted successfully" "Failed to delete group $GROUPNAME"
}

# Function to list groups
function list_groups() {    
    groups=$(cut -d: -f1 /etc/group)
    whiptail --msgbox "List Groups:\n$groups" 0 0
}

# Function to display information about this program
function info_about_program() {
    whiptail --msgbox "This program is a user and group management tool using whiptail for an interactive UI.                                             - Designed By: Baher Fawzy Mikhael Tawfik  " 20 60 --title "Information"
}

# Main loop to show the menu and perform selected actions
while true; do
    CHOICE=$(whiptail --title "User and Group Management" --menu "Choose an option" 20 60 13 \
    "1" "Add User" \
    "2" "Modify User" \
    "3" "Delete User" \
    "4" "List Users" \
    "5" "Enable User" \
    "6" "Disable User" \
    "7" "Change Password" \
    "8" "Add Group" \
    "9" "Modify Group" \
    "10" "Delete Group" \
    "11" "List Groups" \
    "12" "Information about this Program" \
    "13" "Exit" 3>&2 2>&1 1>&3)

    case $CHOICE in
        1) add_user ;;
        2) modify_user ;;
        3) delete_user ;;
        4) list_users ;;
        5) enable_user ;;
        6) disable_user ;;
        7) change_password ;;
        8) add_group ;;
        9) modify_group ;;
        10) delete_group ;;
        11) list_groups ;;
        12) info_about_program ;;
        13) break ;;
    esac
done
