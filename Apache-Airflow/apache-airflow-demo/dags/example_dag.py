from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    "parallel_tasks",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
) as dag:

    t1 = BashOperator(
        task_id="task_1",
        bash_command="sleep 10"
    )

    t2 = BashOperator(
        task_id="task_2",
        bash_command="sleep 10"
    )

    t3 = BashOperator(
        task_id="task_3",
        bash_command="sleep 10"
    )

    [t1, t2] >> t3
