from pyspark import SparkContext

sc = SparkContext("local", "CustomOutput")
file = sc.textFile("hdfs://namenode:9000/spark/file1.txt")
def parse_line(line):
    result = []
    current = ""
    in_quotes = False
    for char in line:
        if char == '"':
            in_quotes = not in_quotes
        elif char == ',' and not in_quotes:
            result.append(current.strip())
            current = ""
        else:
            current += char
    result.append(current.strip())
    processed = [
        int(result[0]),                        
        int(result[1]),                        
        int(float(result[2])),             
        0,                                     
        result[4].strip('"'),               
        result[5].strip('"'),             
        0,                                  
        int(result[7]),                    
        int(result[8]) if len(result) > 8 and result[8].strip() else 0 
    ]
    return processed
step = file.map(parse_line)
result = step.collect()
for row in result:
    print(row)
sc.stop()