import time

print("packages import test - ", end="")
start_time = time.time()
#import numpy as np
import pandas as pd
# also make sure to include fast parquet
#import csv
#import openai
import ast
from openai import OpenAI
import re
import os
from dotenv import load_dotenv, dotenv_values



end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")


# Load Data into a
#save it into a parquet
print("recipes dataset to parquet - ", end="")
start_time = time.time()
df = pd.read_parquet('recipes.parquet')

unique_tags = set(tag for tags_list in df['tags'] for tag in tags_list)
unique_tags_string = ', '.join(unique_tags)
unique_ingredients = set(ingredient for ingredient_list in df['ingredients'] for ingredient in ingredient_list)

end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")





def complexity_sort(df, ascending = True): #pass in your dataframe and if you want ascending to descrending
    return df.sort_values(by='n_steps', ascending=ascending)

def ingredients_sort(df, ascending = False): #pass in your dataframe and if you want ascending to descrending
    return df.sort_values(by='n_ingredients', ascending=ascending)

def time_sort(df, ascending = True): #pass in your dataframe and if you want ascending to descrending
    return df.sort_values(by='minutes', ascending=ascending)

def filter_by_tags(df, tags, total_tag_list):
    valid_tags = [tag for tag in tags if tag in total_tag_list]
    mask = df['tags'].apply(lambda x: any(tag in x for tag in valid_tags))
    filtered_df = df[mask]
    return filtered_df

def filter_by_ingredients(df, ingredients, total_ingredient_list):
    valid_ingredients = [ingredient for ingredient in ingredients if ingredient in total_ingredient_list]
    mask = df['ingredients'].apply(lambda x: any(ingredient in x for ingredient in valid_ingredients))
    filtered_df = df[mask]
    return filtered_df

def add_percent_ingredient_match_column(df, ingredients):
    # Define a function to calculate the percent ingredient match for a single row
    def calculate_match(row):
        intersection = set(ingredients) & set(row['ingredients'])
        if len(ingredients) == 0:
            return 0
        return (len(intersection) / len(ingredients)) 

def add_percent_tag_match_column(df, tags):
    # Define a function to calculate the percent tag match for a single row
    def calculate_match(row):
        intersection = set(tags) & set(row['tags'])
        if len(tags) == 0:
            return 0
        return (len(intersection) / len(tags)) 


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
        {"role": "system", "content": "You are a helpful assistant with the design of helping the user come up with a meal that they want to eat, your questions should be clear and concise with only one question at a time. When you finally have a meal to suggest, you will select the tags that make the most sense for it and make sure you have at least 5 tags. Make sure to only suggest the tags and not the actual meal itself. Also make sure to surround the tags in []. The tags you are allowed to chooose from are as follows: " + unique_tags_string},
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
        #print("Extracted Tags:", GPTtags)

        prompt_messages.append({"role": "system", "content": response_message})

    for column in df.columns:
        print(f"{column}: ", end="")
        print(df[column].apply(type).unique())

    filtertags = GPTtags
    filteringredients = unique_ingredients

    filtered_df = filter_by_tags(df, filtertags, unique_ingredients)
    filtered_df = filter_by_ingredients(filtered_df, filteringredients, unique_ingredients)
    print(len(filtered_df))

    if (len(filtered_df) != 0):
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