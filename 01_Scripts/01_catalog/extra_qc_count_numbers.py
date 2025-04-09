def count_numbers_in_ranges(filename):
    # Define ranges and their counters
    ranges = {
        '0 to 250': 0,
        '251 to 999': 0,
        '1000 to 5000': 0,
        '5001 to 10000': 0,
        '10001 to 25000': 0,
        'Above 25000': 0
    }

    # Read numbers from file and count occurrences in each range
    with open(filename, 'r') as file:
        for line in file:
            number = int(line.strip())
            if 0 <= number <= 250:
                ranges['0 to 250'] += 1
            elif 251 <= number <= 999:
                ranges['251 to 999'] += 1
            elif 1000 <= number <= 5000:
                ranges['1000 to 5000'] += 1
            elif 5001 <= number <= 10000:
                ranges['5001 to 10000'] += 1
            elif 10001 <= number <= 25000:
                ranges['10001 to 25000'] += 1
            elif number > 25000:
                ranges['Above 25000'] += 1

    # Print the counts for each range
    for range_str, count in ranges.items():
        print(f"{range_str}: {count}x")

# Call the function with the filename
count_numbers_in_ranges('test')

