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

# Function to display the main menu
display_main_menu() {
    clear
    echo "Interactive Lesson Planner"
    echo "1. View Lesson Plan Summary"
    echo "2. Start Lesson Planner"
    echo "3. Exit"
}

# Function to display the lesson planner menu
display_lesson_planner_menu() {
    clear
    echo "Lesson Planner"
    echo "1. Next Week"
    echo "2. Previous Week"
    echo "3. Jump to Specific Week"
    echo "4. View Lesson Plan Summary"
    echo "5. Exit to Main Menu"
}

# Function to handle user input for the main menu
handle_main_menu_input() {
    while true; do
        display_main_menu
        read -p "Enter your choice: " choice
        case $choice in
            1)
                display_lesson_plan_summary
                read -p "Press Enter to return to menu..."
                ;;
            2)
                handle_lesson_planner_menu_input  # Call function to handle lesson planner menu
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
    done
}

# Function to handle user input for the lesson planner menu
handle_lesson_planner_menu_input() {
    while true; do
        display_lesson_planner_menu
        read -p "Enter your choice: " choice
        case $choice in
            1)
                ((current_week_index++)) ;;
            2)
                ((current_week_index--)) ;;
            3)
                read -p "Enter the week number to jump to: " week_number
                # Find the index of the specified week directory
                new_week_index=-1
                for i in "${!week_directories[@]}"; do
                    dir="${week_directories[$i]}"
                    if [[ $dir == "week_$week_number" ]]; then
                        new_week_index=$i
                        break
                    fi
                done
                if [ $new_week_index -ge 0 ]; then
                    current_week_index=$new_week_index
                else
                    echo "Week not found."
                fi
                ;;
            4)
                display_lesson_plan_summary
                read -p "Press Enter to return to menu..."
                ;;
            5)
                break ;;
            *)
                echo "Invalid choice. Please enter a number from 1 to 5."
                read -p "Press Enter to return to menu..."
                ;;
        esac
    done
}

# Main function
main() {
    # Array of week directories sorted by name
    week_directories=($(ls -d week_* | sort))

    # Start index for week directories
    current_week_index=0

    while [ $current_week_index -ge 0 ] && [ $current_week_index -lt ${#week_directories[@]} ]; do
        week_directory=${week_directories[$current_week_index]}

        # Display lesson titles for the current week
        display_lesson_titles "$week_directory"

        # Prompt user for lesson number or command
        read -p "Enter the lesson number, 'n' for next, 'p' for previous, 'w' to select a week, or 'q' to quit: " input
        case $input in
            n)
                ((current_week_index++)) ;;
            p)
                ((current_week_index--)) ;;
            w)
                read -p "Enter the week number to jump to: " week_number
                # Find the index of the specified week directory
                new_week_index=-1
                for i in "${!week_directories[@]}"; do
                    dir="${week_directories[$i]}"
                    if [[ $dir == "week_$week_number" ]]; then
                        new_week_index=$i
                        break
                    fi
                done
                if [ $new_week_index -ge 0 ]; then
                    current_week_index=$new_week_index
                else
                    echo "Week not found."
                fi
                ;;
            q)
                break ;;
            [0-9]*)
                lesson_file="$week_directory/lesson_$input.txt"
                display_lesson "$lesson_file"
                read -p "Press Enter to continue..."
                ;;
            *)
                echo "Invalid input. Please enter a lesson number, 'n', 'p', 'w', or 'q'." ;;
        esac
    done
}

# Call the function to handle menu input
handle_main_menu_input
