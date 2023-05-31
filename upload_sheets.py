import gspread
import csv
import boto3

gc = gspread.service_account(filename='credentials.json')

sheet = gc.open('consolidado_med')

worksheet = sheet.sheet1

csv_data = worksheet.get_all_values()

with open ('consolidado_med.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(csv_data)

s3 = boto3.client('s3')
bucket_name = 'mask-amino'
s3.upload_file('consolidado_med.csv', bucket_name, 'consolidado_med.csv')