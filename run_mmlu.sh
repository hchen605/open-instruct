#!/bin/bash
#SBATCH -J job_id
#SBATCH -o ./log/llama3-8b-awq-4bit-mmlu.out
#SBATCH --gres=gpu:1 #Number of GPU devices to use [0-2]
#SBATCH --nodelist=leon05 #YOUR NODE OF PREFERENCE

# Set Hugging Face token
#export CUDA_VISIBLE_DEVICES=0,1
export PYTHONHTTPSVERIFY=0

module load shared singularity 

#singularity exec --nv ../llm-awq/img/llm-awq.img wget https://people.eecs.berkeley.edu/~hendrycks/data.tar --no-check-certificate
#singularity exec --nv ../llm-awq/img/llm-awq.img tar -xopf data.tar
#singularity exec --nv ../llm-awq/img/llm-awq.img git clone https://github.com/sylinrl/TruthfulQA.git

# # eval mmlu
# singularity exec --nv ../llm-awq/img/llm-awq.img \
#     python -m eval.mmlu.run_eval \
#     --ntrain 0 \
#     --data_dir data_mmlu \
#     --save_dir results/mmlu/llama3-8B-raw-0shot \
#     --model_name_or_path ../Meta-Llama-3-8B \
#     --tokenizer_name_or_path ../Meta-Llama-3-8B \
#     --eval_batch_size 16 \

#singularity exec --nv ./img/awq-openai-triton.img pip list
# eval mmlu awq #../LLM-Pruner/img/llm-pruner-awq.img\
singularity exec --nv ./img/awq-openai-triton.img \
    python -m eval.mmlu.run_eval_awq \
    --ntrain 0 \
    --data_dir data_mmlu \
    --save_dir results/mmlu/llama3-8B-awq-4bit-0shot \
    --model_name_or_path /home/hsin/AutoAWQ/Llama-3-8B-AWQ \
    --tokenizer_name_or_path /home/hsin/AutoAWQ/Llama-3-8B-AWQ \
    --awq \
    --eval_batch_size 16 \

