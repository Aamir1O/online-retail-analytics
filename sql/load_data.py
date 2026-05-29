import pandas as pd
from sqlalchemy import create_engine

# Read cleaned CSV
df = pd.read_csv("../data/processed/online_retail_cleaned.csv")

# PostgreSQL connection
# Replace YOUR_PASSWORD with your PostgreSQL password
engine = create_engine(
    "postgresql+psycopg2://postgres:1234@localhost:5432/retail_sales_analytics"
)

# Load data into PostgreSQL
df.to_sql(
    name="online_retail_sales",
    con=engine,
    if_exists="replace",
    index=False,
    chunksize=10000
)

print("Data loaded successfully")
print(f"Rows loaded: {len(df):,}")