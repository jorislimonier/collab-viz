import pandas as pd
from load_data import LoadData


class Sankey():
    def __init__(self):
        # df to export in the end
        self.sankey_col = ["source", "target", "value", "aaa"]
        self.sankey_df = pd.DataFrame(columns=self.sankey_col)

    def append_to_df(self, df):
        df.columns = self.sankey_col
        self.sankey_df = self.sankey_df.append(df)


class TypeGender():
    @classmethod
    def __init__(cls):
        cls.generate_sankey_df()

    @classmethod
    def generate_sankey_df(cls):
        try:
            df = LoadData.artists_data.copy()
        except AttributeError:
            LoadData.load_artists_data()
            df = LoadData.artists_data.copy()
        df = df.groupby(["type", "gender"], dropna=False).count()
        df = df.reset_index()
        df = df.drop(columns=["location", "members"], errors="ignore")
        df = df.rename(columns={"_id": "value"})
        df = df.fillna({col: "unknown_"+col for col in df.columns})
        df = df.replace({col: {"Other": "unknown_"+col for _ in df.columns}
                        for col in df.columns})
        cls.df = df



