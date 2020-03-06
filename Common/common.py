import random


def random_number_for_comment(lower, upper, exclude):
    exclude = [exclude]
    while True:
        val = random.randint(lower, upper - 1)
        if val not in exclude:
            return val
