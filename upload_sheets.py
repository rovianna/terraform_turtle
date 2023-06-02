import gspread
import csv
import boto3
import logging

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

logger = logging.getLogger('sheets_logger')

file_handler = logging.FileHandler('app.log')
file_handler.setLevel(logging.INFO)
file_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))

stream_handler = logging.StreamHandler()
stream_handler.setLevel(logging.DEBUG)
stream_handler.setFormatter(logging.Formatter('%(levelname)s - %(message)s'))

logger.addHandler(file_handler)
logger.addHandler(stream_handler)

logger.debug('Process started...')

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