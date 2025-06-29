# 准确性评估功能使用指南

## 概述

我们增强了知识图谱攻击实验框架，添加了**准确性评估**功能，这是验证攻击有效性和检测虚假自信现象的关键指标。

## 新增功能

### 1. 准确性评估 (Accuracy Assessment)
- **基线准确性**: 测量原始模型回答的准确性
- **攻击后准确性**: 测量被污染模型回答的准确性  
- **准确性下降**: 量化攻击造成的知识损失

### 2. 虚假自信检测 (False Confidence Detection)
- 检测"准确性下降但置信度提高"的情况
- 量化模型对错误答案的过度自信程度

### 3. 攻击有效性指标 (Attack Effectiveness Metrics)
- **攻击成功率**: 成功翻转知识的比例
- **失真度vs准确性相关性**: 分析两种评估方式的关系

## 使用方法

### 步骤1: 运行增强版评估

使用v3版本的探测评估脚本：

```bash
# 单个目标测试
python 04_probe_and_evaluate_v3.py --target-id hc_edge_0 --use-gpt4o --assess-confidence

# 主要参数说明:
# --target-id: 攻击目标ID
# --use-gpt4o: 使用GPT-4o进行准确性评估 (推荐)
# --assess-confidence: 计算置信度分数 (用于虚假自信检测)
# --max-probes: 限制探测问题数量
# --output-dir: 结果输出目录 (默认: results_v3)
```

### 步骤2: 批量运行实验

修改编排脚本以使用v3版本：

```bash
# 需要修改 05_orchestrate_experiment_v2.py 中的脚本调用
# 将 "04_probe_and_evaluate_v2.py" 改为 "04_probe_and_evaluate_v3.py"
python 05_orchestrate_experiment_v2.py
```

### 步骤3: 分析结果

使用v3版本的结果分析脚本：

```bash
python 06_analyze_results_v3.py --results-dir results_v3 --output-dir analysis_output_v3
```

## 结果解读

### 关键指标

1. **baseline_accuracy_rate**: 基线模型的平均准确率
2. **attacked_accuracy_rate**: 攻击后模型的平均准确率  
3. **accuracy_drop**: 准确性下降幅度
4. **attack_success_rate**: 攻击成功率 (知识被成功翻转的比例)
5. **false_confidence_instances**: 虚假自信实例数量

### 示例结果解读

```json
{
  "summary_metrics": {
    "baseline_accuracy_rate": 0.756,     // 基线准确率75.6%
    "attacked_accuracy_rate": 0.423,     // 攻击后准确率42.3%  
    "accuracy_drop": 0.333,              // 准确性下降33.3%
    "attack_success_rate": 0.667         // 66.7%的攻击成功
  },
  "enhanced_features": {
    "false_confidence_instances": [       // 虚假自信实例
      {
        "probe_index": 2,
        "accuracy_drop": 0.8,            // 准确性下降80%
        "confidence_gain": 0.15           // 置信度提高15%
      }
    ]
  }
}
```

### 可视化分析

v3分析脚本生成的图表包括：

1. **accuracy_analysis_v3.png**: 
   - 准确性对比 (按类别)
   - 准确性下降分析
   - 涟漪效应 (按hop距离)
   - 虚假自信分布

2. **attack_effectiveness_v3.png**:
   - 攻击成功率对比
   - 失真度vs准确性下降相关性

## 测试验证

运行测试脚本验证功能：

```bash
python test_accuracy_assessment.py
```

这会：
1. 测试单个目标的v3评估
2. 验证结果文件格式
3. 测试v3结果分析功能

## 重要差异对比

| 指标 | v2版本 (仅失真度) | v3版本 (增加准确性) |
|------|------------------|-------------------|
| 评估维度 | 语义相似度 | 语义相似度 + 事实准确性 |
| 攻击验证 | 间接 (通过embedding距离) | 直接 (是否回答正确) |
| 虚假自信 | 无法检测 | 可以检测和量化 |
| 统计检验 | 基于失真度 | 基于准确性下降 |

## 下一步建议

1. **优先级最高**: 完成准确性评估 (使用v3版本)
2. **中等优先级**: 扩展multi-hop分析 (2-4 hops)
3. **低优先级**: 添加更多图论特征分析

## 故障排除

### 常见问题

1. **GPT-4o API错误**: 
   - 检查API key设置: `export OPENAI_API_KEY=your_key`
   - 或使用 `--openai-api-key` 参数

2. **置信度计算失败**:
   - 尝试禁用: `--no-assess-confidence`

3. **内存不足**:
   - 减少探测数量: `--max-probes 5`

4. **结果文件不存在**:
   - 确保LoRA适配器存在于 `lora_adapters/` 目录
   - 检查目标ID是否正确

### 调试模式

添加详细输出进行调试：

```bash
python 04_probe_and_evaluate_v3.py --target-id hc_edge_0 --max-probes 2 --use-gpt4o 2>&1 | tee debug.log
```

这个增强版本为你的实验提供了更准确和全面的评估指标，特别是准确性评估这一核心指标，能够直接验证攻击的有效性并检测虚假自信现象。 
 
 
 