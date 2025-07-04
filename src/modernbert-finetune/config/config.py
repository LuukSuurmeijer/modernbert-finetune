from dataclasses import dataclass, field
from typing import List


@dataclass
class TrainConfig:
    model_checkpoint: str = "answerdotai/ModernBERT-base"
    dataset_name: str = "ssmits/fineweb-2-dutch"
    num_train_epochs: int = 1
    per_device_train_batch_size: int = 4
    gradient_accumulation_steps: int = 2
    eval_size_ratio: float = 0.05
    masking_probabilities: List[float] = field(
        default_factory=lambda: [0.3, 0.2, 0.18, 0.16, 0.14]
    )
    estimated_dataset_size_in_rows: int = 86500000
    username: str = "ssmits"
    total_save_limit: int = 2
    push_interval: int = 100000
    eval_size_per_chunk: int = 5000
    learning_rate: float = 5e-4
    weight_decay: float = 0.01
    tokenizer_path: str = "domain_tokenizer"
