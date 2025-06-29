#!/bin/bash

# 知识图谱攻击实验环境设置和运行脚本
# 使用方法: ./setup_and_run.sh [实验类型] [参数...]

echo "=========================================="
echo "知识图谱攻击实验环境设置"
echo "=========================================="

# 设置OpenAI API密钥

echo "✅ OpenAI API密钥已设置"

# 检查命令行参数
if [ $# -eq 0 ]; then
    echo "用法示例:"
    echo "  ./setup_and_run.sh test                     # 运行小规模测试"
    echo "  ./setup_and_run.sh batch [参数...]         # 运行批量实验"
    echo "  ./setup_and_run.sh full                     # 运行完整30目标实验"
    echo "  ./setup_and_run.sh poison hc_edge_0 10     # 生成投毒数据"
    echo "  ./setup_and_run.sh eval hc_edge_0          # 评估单个目标"
    exit 1
fi

EXPERIMENT_TYPE=$1
shift

case $EXPERIMENT_TYPE in
    "test")
        echo "🧪 启动小规模测试实验..."
        ./run_batch_experiment.sh --max-targets 1 --max-hops 1 --num-poison-examples 5
        ;;
    "batch")
        echo "📊 启动批量实验..."
        ./run_batch_experiment.sh "$@"
        ;;
    "full")
        echo "🚀 启动完整30目标实验..."
        ./start_full_experiment.sh
        ;;
    "poison")
        if [ $# -lt 2 ]; then
            echo "用法: ./setup_and_run.sh poison <target_id> <num_samples>"
            exit 1
        fi
        TARGET_ID=$1
        NUM_SAMPLES=$2
        echo "💉 生成投毒数据: $TARGET_ID ($NUM_SAMPLES 样本)..."
        python 02_generate_poison_data_v2.py --target-id "$TARGET_ID" --num-samples "$NUM_SAMPLES"
        ;;
    "eval")
        if [ $# -lt 1 ]; then
            echo "用法: ./setup_and_run.sh eval <target_id>"
            exit 1
        fi
        TARGET_ID=$1
        echo "📈 评估目标: $TARGET_ID..."
        python 04_probe_and_evaluate_v3_no_cache.py "$TARGET_ID"
        ;;
    "multihop")
        if [ $# -lt 1 ]; then
            echo "用法: ./setup_and_run.sh multihop <target_id> [max_hops]"
            exit 1
        fi
        TARGET_ID=$1
        MAX_HOPS=${2:-3}
        echo "🔗 多跳分析: $TARGET_ID (最大${MAX_HOPS}跳)..."
        python 07_evaluate_multi_hop_effect.py "$TARGET_ID" --max-hops "$MAX_HOPS"
        ;;
    *)
        echo "❌ 未知实验类型: $EXPERIMENT_TYPE"
        echo "支持的类型: test, batch, full, poison, eval, multihop"
        exit 1
        ;;
esac

echo "✅ 实验命令已执行" 