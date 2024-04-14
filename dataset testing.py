import pandas as pd
# also make sure to include fast parquet
#import csv
#import openai
# import ast
# from openai import OpenAI
# import re
# import os
from dotenv import load_dotenv, dotenv_values
import time

# Load Data into a
#save it into a parquet
print("read + Process recipes parquet - ", end="")
start_time = time.time()
df = pd.read_parquet('recipes.parquet')

unique_tags = set(tag for tags_list in df['tags'] for tag in tags_list)
unique_ingredients = set(ingredient for ingredient_list in df['ingredients'] for ingredient in ingredient_list)

#print(unique_tags)
print(len(df['tags'].head(1)))

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
    # Calculate the composite match as the multiplication of ingredient and tag matches
    df['composite_match'] = (df['percent_ingredient_match'] * df['percent_tag_match']) 
    return df


print (unique_tags)
num_ingredient_matches = 0
num_tag_matches = 0
filtertags = {'Brunch', 'Savory', 'Breakfast or Lunch', 'Asian Cuisine', 'Leisure Cooking', 'halloween oreo cookies', 'tomato and basil pasta sauce', 'canton ginger and cognac liqueur', 'coriander root', 'family-size tea bags'}
for i in filtertags:
    if i in unique_ingredients:
        num_ingredient_matches += 1
    if i in unique_tags:
        num_tag_matches += 1

print("NUMBER OF MATCHES:")
print(f"ingredients: {num_ingredient_matches}")
print(f"tags: {num_tag_matches}")


import spacy
print(unique_ingredients.type())
print(unique_tags.type())

print("keyword search - ", end="")
start_time = time.time()
# Load a large English model
nlp = spacy.load("en_core_web_sm")
# Assume a very large list of keywords
keywords = unique_ingredients  # Large number of items MAKE SURETHIS IS INGREDIENTS
# Process keywords in advance and store their Lemmas
keyword_lemmas = set([nlp(keyword)[0].lemma_ for keyword in keywords])

# Search prompt
search_prompt = "I love chinese food and want to make something that doesn't take too long and make sure it has beef that is stir fried in some way shape or form"

# Process the search prompt
doc = nlp(search_prompt.lower())

# Find matches using precomputed lemma set
matches = [token.text for token in doc if token.lemma_ in keyword_lemmas]

print("NLP matched keywords:", matches)
end_time = time.time()
elapsed_time = end_time - start_time
print(f"SUCCESS: {elapsed_time} seconds")