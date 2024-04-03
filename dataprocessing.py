import time

print("packages import test - ", end="")
start_time = time.time()
import numpy as np
import pandas as pd
# also make sure to include fast parquet
import csv
import openai
import ast
from openai import OpenAI
import re
import os
from dotenv import load_dotenv, dotenv_values



end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")


# Load Data into a
file_path = 'RAW_recipes.csv'  # Replace 'data.csv' with the path to your CSV file

#import the file - + time it
print("csv import test - ", end="")
start_time = time.time()
df = pd.read_csv(file_path);
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")

print("tags processing - ", end="")
start_time = time.time()
df['tags'] = df['tags'].apply(ast.literal_eval)  # Convert the strings in the column to a list
df['tags'] = df['tags'].apply(lambda x: [tag.replace('-', ' ') for tag in x])  # Replace hyphens with spaces in each tag
# Grab all of the unique tags in the tags column
unique_tags = set(tag for tags_list in df['tags'] for tag in tags_list)
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")

print("steps processing - ", end="")
start_time = time.time()
df['steps'] = df['steps'].apply(ast.literal_eval) # convert the strrings in the thing to a list
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")

print("ingredients processing - ", end="")
start_time = time.time()
df['ingredients'] = df['ingredients'].apply(ast.literal_eval) # convert the strrings in the thing to a list
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds\n")

print("num ingredients processing - ", end="")
start_time = time.time()
df['n_ingredients'] = pd.to_numeric(df['n_ingredients'], errors='coerce')
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")

print("minutes processing - ", end="")
start_time = time.time()
df['minutes'] = pd.to_numeric(df['minutes'], errors='coerce')
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")

print("num steps processing - ", end="")
start_time = time.time()
df['n_steps'] = pd.to_numeric(df['n_steps'], errors='coerce')
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds\n")

print("remove error values - ", end="")
start_time = time.time()
rowsPre = len(df)
df = df.dropna()
rowsPost = len(df)
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")
print(f"{rowsPre} - {rowsPost} = {rowsPre - rowsPost} rows lost\n")

#save it into a parquet
print("recipes dataset to parquet - ", end="")
start_time = time.time()
df.to_parquet('recipes.parquet')
df = pd.read_parquet('recipes.parquet')
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")

def complexity_sort(df, ascending = True): #pass in your dataframe and if you want ascending to descrending
    return df.sort_values(by='n_steps', ascending=ascending)

def ingredients_sort(df, ascending = False): #pass in your dataframe and if you want ascending to descrending
    return df.sort_values(by='n_ingredients', ascending=ascending)

def time_sort(df, ascending = True): #pass in your dataframe and if you want ascending to descrending
    return df.sort_values(by='minutes', ascending=ascending)

def filter_by_tags(df, tags): #pass in tags and tag list
    mask = df['tags'].apply(lambda x: any(tag in x for tag in tags))
    filtered_df = df[mask]
    return filtered_df

def filter_by_ingredients(df, ingredients): #pass in tags and tag list
    mask = df['ingredients'].apply(lambda x: any(ingredient in x for ingredient in ingredients))
    filtered_df = df[mask]
    return filtered_df

def add_percent_ingredient_match_column(df, ingredients):
    # Define a function to calculate the percent ingredient match for a single row
    def calculate_match(row):
        intersection = set(ingredients) & set(row['ingredients'])
        if len(ingredients) == 0:
            return 0
        return (len(intersection) / len(ingredients)) 

    # Apply the calculate_match function to each row
    df['percent_ingredient_match'] = df.apply(calculate_match, axis=1)
    return df


def add_percent_tag_match_column(df, tags):
    # Define a function to calculate the percent tag match for a single row
    def calculate_match(row):
        intersection = set(tags) & set(row['tags'])
        if len(tags) == 0:
            return 0
        return (len(intersection) / len(tags)) 

    # Apply the calculate_match function to each row
    df['percent_tag_match'] = df.apply(calculate_match, axis=1)
    return df

def add_composite_match_column(df):
    # Calculate the composite match as the average of ingredient and tag matches
    df['composite_match'] = (df['percent_ingredient_match'] * df['percent_tag_match']) 
    return df

def create_chat_completion(prompt_messages):
    load_dotenv()

    client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

    completion = client.chat.completions.create(
        # model="gpt-3.5-turbo",
        model = "gpt-4-turbo-preview",
        messages = prompt_messages,
        temperature = 0.7,
        max_tokens = 150,
        top_p = 1.0,
        frequency_penalty = 0.0,
        presence_penalty = 0.0
    )

    return completion.choices[0].message.content


def extract_tags_from_response(response):

    # filters everything with [] symbol thingy
    tags = set(re.findall(r'\[([^\]]+)\]', response))
    return tags

#MAIN STUFF


def main():
    prompt_messages = [
        {"role": "system", "content": "You are a helpful assistant with the design of helping the user come up with tags to search recipies for. Tags should look something like [15 minutes or less], or [occasion]. You should ask the users a few questions until you come up with about five tags, your questions should be clear and concise with only one question at a time"},
    ]

    print("What type of food are you feeling right now? Type 'quit' to exit.")
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'quit':
            print("Exiting chat...")
            break

        prompt_messages.append({"role": "user", "content": user_input})

        response_message = create_chat_completion(prompt_messages)
        # response_content = response_message['content']
        print("AI:", response_message)

        GPTtags = extract_tags_from_response(response_message)
        print("Extracted Tags:", GPTtags)

        prompt_messages.append({"role": "system", "content": response_message})

    for column in df.columns:
        print(f"{column}: ", end="")
        print(df[column].apply(type).unique())

    filtertags = GPTtags
    filteringredients = {"eggs", "chicken"}

    filtered_df = filter_by_tags(df, filtertags)
    filtered_df = filter_by_ingredients(filtered_df, filteringredients)
    print(len(filtered_df))

    add_percent_ingredient_match_column(filtered_df, filteringredients)
    add_percent_tag_match_column(filtered_df, filtertags)
    add_composite_match_column(filtered_df)

    print(filtered_df.head(20))





if __name__ == "__main__":
    main()

#print (df.columns.tolist())
#['name', 'id', 'minutes', 'contributor_id', 'submitted', 'tags', 'nutrition', 'n_steps', 'steps', 'description', 'ingredients', 'n_ingredients']
#unique_tags = list(set(item for sublist in df['tags'] for item in sublist))

#print(df['tags'].head(20))
#print(unique_tags)