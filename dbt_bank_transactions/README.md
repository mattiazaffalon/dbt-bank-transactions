# Run dbt for this project

from directory above
```bash
source .venv/bin/activate

pip install -r requirements.txt
```

from this directory
```bash
dbt deps
```
Running the project
```bash
dbt run-operation stage_external_sources && \
    dbt seed && \ 
    dbt run && \
    dbt test
```