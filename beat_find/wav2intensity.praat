
infile$ = readFile$ ("file.inf")

low$ = "150"
high$ = "1150"

name$ = infile$-".wav"

# Read in the file
 Read from file... 'infile$'

# Scale the intensity
Scale intensity... 70

# Band pass filter
Filter (pass Hann band)... 'low$' 'high$' 100

# Convert to intensity
To Intensity... 25 0 yes

Write to short text file... beats/'name$'.intensity
