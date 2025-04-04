#!/bin/bash

# Initialize Conda properly for THIS shell
__conda_setup="$('/home/parv/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/parv/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/parv/anaconda3/etc/profile.d/conda.sh"  # Use '.' instead of 'source'
    else
        export PATH="/home/parv/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Fix for child terminals: Explicitly use bash and source conda
{
    gnome-terminal --tab "roscore_node" -- bash -c \
    "source /home/parv/anaconda3/etc/profile.d/conda.sh && roscore; exec bash"
}&
sleep 2s

BENCHMARK_ROOT=$(pwd)
task_name="Merom_1_int_Task1"

# Activate environment
conda activate omnigibson  # Now works in parent script

# Fix activation in child terminal
{
    gnome-terminal --tab "LLM" -- bash -c \
    "source /home/parv/anaconda3/etc/profile.d/conda.sh && \
    conda activate omnigibson && \
    python3 $BENCHMARK_ROOT/ros_hademo_ws/src/hademo/src/action_publisher.py --task_name $task_name; exec bash"
}&
sleep 2s

python3 "$BENCHMARK_ROOT/sim.py" --task_name "$task_name"
