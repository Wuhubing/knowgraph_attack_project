#!/bin/bash

# 批量实验后台运行脚本
# 使用方法: ./run_batch_experiment.sh [参数]

# 设置默认参数
MAX_HOPS=4
NUM_POISON=100
MAX_TARGETS=30
START_FROM=0
OUTPUT_DIR="batch_experiment_results"

# 创建时间戳
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="batch_experiment_${TIMESTAMP}.log"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --max-hops)
            MAX_HOPS="$2"
            shift 2
            ;;
        --num-poison|--num-poison-examples)
            NUM_POISON="$2"
            shift 2
            ;;
        --max-targets)
            MAX_TARGETS="$2"
            shift 2
            ;;
        --start-from)
            START_FROM="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  --max-hops NUM        最大跳数分析 (默认: 4)"
            echo "  --num-poison NUM      投毒样本数量 (默认: 100)"
            echo "  --num-poison-examples NUM  投毒样本数量 (同上，兼容参数)"
            echo "  --max-targets NUM     最大目标数量 (默认: 30)"
            echo "  --start-from NUM      起始目标索引 (默认: 0)"
            echo "  --output-dir DIR      输出目录 (默认: batch_experiment_results)"
            echo "  --help, -h            显示此帮助信息"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            echo "使用 --help 查看帮助信息"
            exit 1
            ;;
    esac
done

echo "=========================================="
echo "批量知识图谱攻击实验启动"
echo "=========================================="
echo "时间戳: $TIMESTAMP"
echo "最大跳数: $MAX_HOPS"
echo "投毒样本数: $NUM_POISON"
echo "最大目标数: $MAX_TARGETS"
echo "起始目标: $START_FROM"
echo "输出目录: $OUTPUT_DIR"
echo "日志文件: $LOG_FILE"
echo "=========================================="

# 检查必要文件
if [ ! -f "08_batch_experiment_pipeline.py" ]; then
    echo "错误: 找不到 08_batch_experiment_pipeline.py"
    exit 1
fi

if [ ! -f "baseline_validation_full.json" ]; then
    echo "错误: 找不到 baseline_validation_full.json"
    exit 1
fi

# 构建Python命令
PYTHON_CMD="python 08_batch_experiment_pipeline.py \
    --max-hops $MAX_HOPS \
    --num-poison-examples $NUM_POISON \
    --max-targets $MAX_TARGETS \
    --start-from $START_FROM \
    --output-dir $OUTPUT_DIR"

echo "执行命令: $PYTHON_CMD"
echo "=========================================="

# 后台运行并记录日志
nohup $PYTHON_CMD > "$LOG_FILE" 2>&1 &

# 获取进程ID
PID=$!

echo "实验已在后台启动!"
echo "进程ID: $PID"
echo "日志文件: $LOG_FILE"
echo ""
echo "监控命令:"
echo "  查看日志: tail -f $LOG_FILE"
echo "  查看进程: ps aux | grep $PID"
echo "  停止实验: kill $PID"
echo ""

# 创建进程信息文件
cat > "batch_experiment_${TIMESTAMP}.pid" << EOF
PID=$PID
TIMESTAMP=$TIMESTAMP
LOG_FILE=$LOG_FILE
START_TIME=$(date)
COMMAND=$PYTHON_CMD
EOF

echo "进程信息已保存到: batch_experiment_${TIMESTAMP}.pid"
echo "=========================================="

# 等待几秒钟，然后显示日志开头
sleep 3
echo "实验日志预览:"
echo "----------------------------------------"
head -20 "$LOG_FILE" 2>/dev/null || echo "日志文件尚未生成，请稍等..."
echo "----------------------------------------"
echo "使用 'tail -f $LOG_FILE' 继续监控日志" 