#!/bin/bash
# Function to run Cypress tests in a Docker container
run_cypress_test() {
  local test_file=$1
  container_id=$(
    docker run -d cypress-image:latest \
    cypress run --spec "$test_file"
  )

  # Wait for the container to finish
  docker wait "$container_id"

  # Copy the JSON report file from the Docker container to the local machine
  docker cp "$container_id:/app/cypress/reports/mocha/." "./cypress/reports/mocha"

  # Remove the container
  docker rm "$container_id"
}

# Clean up existing reports directory
rm -rf cypress/reports
mkdir -p cypress/reports

# Find all test files
ALL_TESTS=$(find . -name '*.cy.js')

# Define maximum number of containers to run tests concurrently
MAX_CONTAINERS=4

# Array to store PIDs of running processes
declare -a PIDS=()

# Loop through all tests and start running them
for test in $ALL_TESTS; do
  run_cypress_test "$test" &
  
  # Save the PID of the background process
  PIDS+=("$!")
  
  # If the number of running processes reaches maximum containers, wait for one to finish
  if [ ${#PIDS[@]} -ge $MAX_CONTAINERS ]; then
    # Wait for any background process to finish
    wait -n
    # Remove the PID of the finished process from the array
    unset 'PIDS[0]'
    # Re-index the array to remove the empty elements
    PIDS=("${PIDS[@]}")
  fi
done

# Wait for all remaining background processes to finish
wait "${PIDS[@]}"

# Report generation
npm run combine-reports && npm run generate-report