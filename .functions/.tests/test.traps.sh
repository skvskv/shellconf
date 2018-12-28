#!/bin/bash

# For more details see https://stackoverflow.com/a/16115145/4649675
# Many thanks to https://stackoverflow.com/users/1449569/iron-savior for the solution

. ../traps-mgmt.func

initial_trap='echo "messy" ;'" echo 'handler'"
non_f_trap='echo "non-function trap"'
f_trap() {
  echo "function trap"
}

print_status() {
  echo "    SIGINT  trap: `get_trap SIGINT`"  
  echo "    SIGTERM trap: `get_trap SIGTERM`"
  echo "-------------"
  echo
}

echo "--- TEST START ---"
echo "Initial trap state (should be empty):"
print_status

echo 'Setting messy non-function handler for SIGINT ("original state")'
trap "$initial_trap" SIGINT
print_status

echo 'Pop empty stacks (still in original state)'
trap_pop SIGINT SIGTERM
print_status

echo 'Push non-function handler for SIGINT'
trap_push "$non_f_trap" SIGINT
print_status

echo 'Append function handler for SIGINT and SIGTERM'
trap_append f_trap SIGINT SIGTERM
print_status

echo 'Prepend function handler for SIGINT and SIGTERM'
trap_prepend f_trap SIGINT SIGTERM
print_status

echo 'Push non-function handler for SIGINT and SIGTERM'
trap_push "$non_f_trap" SIGINT SIGTERM
print_status

echo 'Pop both stacks'
trap_pop SIGINT SIGTERM
print_status

echo 'Prepend function handler for SIGINT and SIGTERM'
trap_prepend f_trap SIGINT SIGTERM
print_status

echo 'Pop both stacks thrice'
trap_pop SIGINT SIGTERM
trap_pop SIGINT SIGTERM
trap_pop SIGINT SIGTERM
print_status

echo 'Push non-function handler for SIGTERM'
trap_push "$non_f_trap" SIGTERM
print_status

echo 'Pop handler state for SIGINT (SIGINT is now back to original state)'
trap_pop SIGINT
print_status

echo 'Pop handler state for SIGTERM (SIGTERM is now back to original state)'
trap_pop SIGTERM
print_status

