import pandas as pd

df = pd.read_csv("gnd-etiras-mappings.csv")

df["toNotation"] = (
    df["041P.u"].combine_first(df["065P.u"])
    .combine_first(df["022P.u"])
    .combine_first(df["030P.u"])
)
df["fromNotation"] = df["039A.0"].combine_first(df["039A.5"])

df["type"] = (
    df["041P.4"].combine_first(df["065P.4"])
    .combine_first(df["022P.4"])
    .combine_first(df["030P.4"])
)

df = df.drop(columns=[
    "041P.u", "065P.u", "022P.u", "030P.u",
    "041P.4", "065P.4", "022P.4", "030P.4",
    "039A.0", "039A.5"
])

df = df.drop_duplicates()
df.to_csv("gnd-etiras-mappings.csv", index=False)