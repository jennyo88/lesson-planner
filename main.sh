#!/bin/bash

# Function to display the lesson plan summary
display_lesson_plan_summary() {
    if [ -f "lesson_plan.txt" ]; then
        clear
        echo "Lesson Plan Summary:"
        cat "lesson_plan.txt"
        echo
    else
        echo "Lesson plan not found."
    fi
}

# Function to display lesson titles for a given week
display_lesson_titles() {
    local week_directory="$1"
    local week_number=$(basename "$week_directory" | cut -d '_' -f 2)
    echo "Week $week_number Lessons:"
    for lesson_file in "$week_directory"/lesson_*.txt; do
        lesson_number=$(basename "$lesson_file" | cut -d '_' -f 2 | cut -d '.' -f 1)
        lesson_title=$(head -n 1 "$lesson_file")
        printf "  %-10s: %s\n" "Lesson $lesson_number" "$lesson_title"
    done
}

# Function to display lesson content
display_lesson() {
    local lesson_file="$1"
    if [ -f "$lesson_file" ]; then
        clear
        echo "Lesson Content:"
        fold -s -w $(tput cols) "$lesson_file" | less -FX  # Wrap lines and use less for interactive viewing
    else
        echo "Lesson not found."
    fi
}

# Function to display the menu
display_menu() {
    clear
    echo "Interactive Lesson Planner Menu"
    echo "1. Display Lesson Plan Summary"
    echo "2. Start Lesson Planner"
    echo "3. Exit"
}

# Function to handle user input for the menu
handle_menu_input() {
    read -p "Enter your choice: " choice
    case $choice in
        1)
            display_lesson_plan_summary
            read -p "Press Enter to return to menu..."
            ;;
        2)
            main
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number from 1 to 3."
            read -p "Press Enter to return to menu..."
            ;;
    esac
}

# Main function
main() {
    while true; do
        display_menu
        handle_menu_input
    done
}

# Call the main function to start the interactive menu
main
