# Knowledge Graph Attack via LLM Fine-tuning (Enhanced Version)

This project implements an advanced experimental framework to study how fine-tuning Large Language Models (LLMs) with poisoned data affects their knowledge representation. The enhanced version includes GPT-4o integration for higher quality data generation and deeper analysis.

## 🚀 Key Enhancements

1. **GPT-4o Powered Data Generation**: Creates more natural and diverse poisoned training data
2. **Intelligent Probe Questions**: Automatically converts knowledge triples to natural language questions
3. **Qualitative Analysis**: Categorizes distortion types (Direct Contradiction, Fact Fabrication, etc.)
4. **Baseline Caching**: Dramatically speeds up experiments by caching baseline model responses
5. **Enhanced Visualizations**: Includes distortion decay analysis, type distribution, and heatmaps

## 📊 Project Architecture

```
knowgraph_attack_project/
├── Core Scripts (Original)
│   ├── 01_select_targets.py          # Select attack targets from knowledge graph
│   ├── 02_generate_poison_data.py    # Generate poisoned training data
│   ├── 03_run_finetune.py          # Fine-tune model with LoRA
│   ├── 04_probe_and_evaluate.py    # Probe model and measure distortion
│   ├── 05_orchestrate_experiment.py # Automate the entire pipeline
│   └── 06_analyze_results.py        # Analyze results and visualizations
│
├── Enhanced Scripts (GPT-4o Powered)
│   ├── 02_generate_poison_data_v2.py  # High-quality poison data with GPT-4o
│   ├── 04_probe_and_evaluate_v2.py   # Smart probing with caching & analysis
│   └── 06_analyze_results_v2.py      # Enhanced analysis with insights
│
├── Data Directories
│   ├── graph_data/                  # Knowledge graph data
│   ├── poison_datasets/            # Generated poisoned datasets  
│   ├── lora_adapters/             # Trained LoRA adapters
│   ├── results/                   # Evaluation results
│   └── analysis_output/           # Analysis reports and visualizations
│
└── Configuration
    ├── requirements.txt           # Python dependencies
    ├── baseline_answers_cache.json # Cached baseline responses (auto-generated)
    └── attack_targets.json        # Selected targets (auto-generated)
```

## 🛠️ Prerequisites

1. **Hardware Requirements**:
   - GPU: At least 16GB VRAM (NVIDIA V100, A100, or better)
   - RAM: 32GB+ recommended
   - Storage: 50GB+ free space

2. **API Access**:
   - **Llama-2**: Hugging Face account with approved access
   - **GPT-4o**: OpenAI API key (for enhanced features)

3. **Environment Setup**:
   ```bash
   # Install dependencies
   pip install -r requirements.txt
   
   # Set API keys
   export HF_TOKEN=your_huggingface_token
   export OPENAI_API_KEY=your_openai_api_key  # For enhanced features
   ```

## 📖 Usage Guide

### Quick Start (Enhanced Version)

```bash
# 1. Select attack targets
python 01_select_targets.py

# 2. Run single attack with GPT-4o enhancement
python 02_generate_poison_data_v2.py --target-id hc_edge_0 --use-gpt4o
python 03_run_finetune.py --target-id hc_edge_0
python 04_probe_and_evaluate_v2.py --target-id hc_edge_0 --use-gpt4o

# 3. Analyze with enhanced insights
python 06_analyze_results_v2.py
```

### Full Experiment Pipeline

```bash
# Process multiple targets automatically
python 05_orchestrate_experiment.py \
    --target-type all \
    --max-targets 20 \
    --skip-generation \    # Skip if poison data exists
    --skip-finetune \      # Skip if LoRA adapter exists
    --parallel 2           # Run 2 processes in parallel

# Generate comprehensive analysis
python 06_analyze_results_v2.py --output-dir analysis_enhanced
```

### Using Original Scripts (Without GPT-4o)

```bash
# If you don't have OpenAI API access
python 02_generate_poison_data.py --target-id hc_edge_0
python 04_probe_and_evaluate.py --target-id hc_edge_0
python 06_analyze_results.py
```

## 🔧 Key Parameters

### Poison Data Generation
- `--num-samples`: Training samples per target (default: 20)
- `--use-gpt4o`: Enable GPT-4o for natural data generation

### LoRA Fine-tuning
- `--epochs`: Training epochs (default: 3)
- `--batch-size`: Batch size (default: 4, reduce if OOM)
- `--learning-rate`: Learning rate (default: 2e-4)

### Evaluation
- `--max-probes`: Number of probe questions (default: 10)
- `--use-gpt4o`: Enable intelligent question generation
- `--use-cache`: Use baseline answer cache (recommended)

## 📊 Understanding Results

### Distortion Metrics
- **Distortion Score**: 0.0 (identical) to 1.0 (completely different)
- **Categories**: High/Low Confidence × High/Low Connectivity

### Enhanced Analysis Features
1. **Distortion Types** (with GPT-4o):
   - Direct Contradiction
   - Fact Fabrication
   - Concept Confusion
   - Subtle Shift
   - No Change

2. **Hop Distance Analysis**:
   - 0-hop: Direct attack target
   - 1-hop: Immediate neighbors
   - 2-hop: Extended neighborhood

3. **Statistical Tests**:
   - T-tests between groups
   - Effect sizes (Cohen's d)
   - Significance levels

## ⚡ Performance Optimization

1. **Baseline Caching**: First run generates cache, subsequent runs are 10x faster
2. **Parallel Processing**: Use `--parallel` flag cautiously (GPU memory)
3. **Skip Flags**: Use `--skip-*` to avoid regenerating existing data
4. **4-bit Quantization**: Reduces memory usage by 75%

## 🔍 Troubleshooting

| Issue | Solution |
|-------|----------|
| CUDA Out of Memory | Reduce `--batch-size` to 1 or 2 |
| OpenAI API Error | Check API key and rate limits |
| No Llama-2 Access | Request access at Hugging Face |
| Slow Baseline Generation | Normal for first run, cache speeds up future runs |

## 📈 Example Results

After running experiments, you'll find:
- `results/`: Individual target results with distortion scores
- `analysis_output/`: Comprehensive visualizations and insights
- `baseline_answers_cache.json`: Speeds up future experiments

## 🧪 Research Applications

This framework enables studying:
1. **Knowledge Robustness**: How resistant are LLMs to targeted misinformation?
2. **Ripple Effects**: How does poisoning one fact affect related knowledge?
3. **Structural Factors**: Do graph properties (confidence, connectivity) affect vulnerability?
4. **Mitigation Strategies**: Can we identify and defend against such attacks?

## ⚠️ Ethical Considerations

This is a research tool for understanding LLM vulnerabilities. Please:
- Use responsibly for defensive security research only
- Do not deploy poisoned models in production
- Consider the implications of your findings
- Cite appropriately in publications

## 📚 Citation

If you use this framework in your research, please cite:
```bibtex
@software{knowgraph_attack,
  title={Knowledge Graph Attack via LLM Fine-tuning},
  author={[Your Name]},
  year={2024},
  url={https://github.com/yourusername/knowgraph_attack}
}
```

## 🤝 Contributing

Contributions welcome! Areas for improvement:
- Additional distortion metrics
- Support for more models (Mistral, Gemma, etc.)
- Graph visualization of attack effects
- Automated defense mechanisms

## 📝 License

This project is for research purposes. Please ensure compliance with model licenses (Llama-2, GPT-4) and use ethically.