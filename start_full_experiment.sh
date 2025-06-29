#!/bin/bash

# 完整30目标4跳批量实验启动脚本
# 这将是一个长时间运行的实验，预计需要10-20小时

echo "=========================================="
echo "完整知识图谱攻击实验 - 30目标4跳分析"
echo "=========================================="
echo "⚠️  警告: 这是一个长时间运行的实验"
echo "预计运行时间: 10-20小时"
echo "将处理30个有效目标，每个目标:"
echo "  - 生成100个投毒样本"
echo "  - LoRA微调攻击"
echo "  - 单跳攻击评估"
echo "  - 4跳涟漪效应分析"
echo "=========================================="

read -p "确认启动完整实验? [y/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "实验取消"
    exit 0
fi

echo "启动完整批量实验..."

# 启动完整实验
./run_batch_experiment.sh \
    --max-targets 30 \
    --max-hops 4 \
    --num-poison 100 \
    --output-dir full_experiment_results

echo ""
echo "✅ 完整实验已启动!"
echo "📊 结果将保存在 full_experiment_results/ 目录下"
echo "📝 使用以下命令监控进度:"
echo "    tail -f batch_experiment_*.log"
echo "==========================================" 