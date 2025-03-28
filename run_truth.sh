#!/bin/bash
#SBATCH -J job_id
#SBATCH -o ./log/llama3-8b-awq-4bit-2k-lora-truthfulqa.out
#SBATCH --gres=gpu:1 #Number of GPU devices to use [0-2]
#SBATCH --nodelist=leon05 #YOUR NODE OF PREFERENCE

# Set Hugging Face token
#export CUDA_VISIBLE_DEVICES=0,1
export PYTHONHTTPSVERIFY=0

module load shared singularity 

#singularity exec --nv ../llm-awq/img/llm-awq.img wget https://people.eecs.berkeley.edu/~hendrycks/data.tar --no-check-certificate
#singularity exec --nv ../llm-awq/img/llm-awq.img tar -xopf data.tar
#singularity exec --nv ../llm-awq/img/llm-awq.img git clone https://github.com/sylinrl/TruthfulQA.git


# eval truthfulqa
# singularity exec --nv ../llm-awq/img/llm-awq.img \
#     python -m eval.truthfulqa.run_eval \
#     --data_dir TruthfulQA/data/v0 \
#     --save_dir results/truthfulqa/llama3-8B-raw \
#     --model_name_or_path ../Meta-Llama-3-8B \
#     --tokenizer_name_or_path ../Meta-Llama-3-8B \
#     --metrics truth info mc \
#     --preset qa \
#     --hf_truth_model_name_or_path allenai/truthfulqa-truth-judge-llama2-7B \
#     --hf_info_model_name_or_path allenai/truthfulqa-info-judge-llama2-7B \
#     --eval_batch_size 20 \

# eval truthfulqa awq
# singularity exec --nv ./img/awq-openai-triton.img \
#     python -m eval.truthfulqa.run_eval_awq \
#     --data_dir TruthfulQA/data/v0 \
#     --save_dir results/truthfulqa/llama3-8B-awq-4bit \
#     --model_name_or_path /home/hsin/AutoAWQ/Llama-3-8B-AWQ \
#     --tokenizer_name_or_path /home/hsin/AutoAWQ/Llama-3-8B-AWQ \
#     --metrics truth info mc \
#     --preset qa \
#     --hf_truth_model_name_or_path allenai/truthfulqa-truth-judge-llama2-7B \
#     --hf_info_model_name_or_path allenai/truthfulqa-info-judge-llama2-7B \
#     --eval_batch_size 20 \
#     --awq \

# eval truthfulqa awq lora
singularity exec --nv ./img/awq-openai-triton-peft.img \
    python -m eval.truthfulqa.run_eval_awq \
    --data_dir TruthfulQA/data/v0 \
    --save_dir results/truthfulqa/llama3-8B-awq-4bit-2k-lora \
    --model_name_or_path /home/hsin/AutoAWQ/Llama-3-8B-AWQ \
    --tokenizer_name_or_path /home/hsin/AutoAWQ/Llama-3-8B-AWQ \
    --metrics truth info mc \
    --preset qa \
    --hf_truth_model_name_or_path allenai/truthfulqa-truth-judge-llama2-7B \
    --hf_info_model_name_or_path allenai/truthfulqa-info-judge-llama2-7B \
    --eval_batch_size 20 \
    --awq --lora \
    --lora_path /home/hsin/AutoAWQ/Llama-3-8B-AWQ-2k-lora-8-16