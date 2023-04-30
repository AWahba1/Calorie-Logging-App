# inistialize class based on prediction result serializer


class PredictionResult():
    def __init__(self, weight, food_item_details):
        self.weight = weight
        self.food_item_details = food_item_details
