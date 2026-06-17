import pandas as pd 
import matplotlib.pyplot as plt 

#readcsv
Df = pd.read_csv("WA_Fn-UseC_-Telco-Customer-Churn.csv")

#dataOVERVIEW
print("Shape_of_dataset",Df.shape)
print("\nColumnsInDataset")
print(Df.columns.tolist())
print("\nTopFiveRows")
print(Df.head())
print("\nDataInformation")
print(Df.info())
print(Df.describe())
print(Df.describe(include='object'))

#DATACheckForNullAndDuplicates
print(Df.isnull().sum())
print(Df.duplicated().sum())


#convertTotalChargestoNumeric
Df['TotalCharges'] = pd.to_numeric(Df['TotalCharges'], errors='coerce')
#checkformissingValues
print(Df.isnull().sum())
#fillthemissingValues
Df['TotalCharges'].fillna(Df['TotalCharges'].median(), inplace=True)
print(Df.isnull().sum())

#convertSeniorCitizen
Df['SeniorCitizen'] = Df['SeniorCitizen'].map({0: 'No', 1: 'Yes'})


#ConvertChurnForNumericalAnalysis
Df['Churn_Flag'] = Df['Churn'].map({'Yes': 1, 'No': 0})

#OverallChurnRate
churn_rate = Df['Churn_Flag'].mean() * 100
print("Churn Rate:", round(churn_rate, 2), "%")
#createGroupsForTenure
Df['tenure_group'] = pd.cut(
    Df['tenure'],
    bins=[0, 12, 24, 48, 72],
    labels=['0-1 Year', '1-2 Years', '2-4 Years', '4+ Years']
)

#createGroupsForMonthlyCharge
Df['charge_group'] = pd.cut(
    Df['MonthlyCharges'],
    bins=[0, 35, 70, 100, 150],
    labels=['Low', 'Medium', 'High', 'Very High']
)
print(Df.groupby('PaperlessBilling')['Churn_Flag'].mean() * 100)
print(Df.groupby('charge_group')['Churn_Flag'].mean() * 100)

#CHECKDATA
print(Df.info())
print(Df.head())

#OverallChurnRate
churn_rate = Df['Churn_Flag'].mean() * 100
print("Churn Rate:", round(churn_rate, 2), "%")


#ChurnDistribution
Df['Churn'].value_counts().plot(
    kind='bar'
)

plt.title("Churn Distribution")
plt.show()


#ChurnByContract
contract_churn = Df.groupby('Contract')['Churn_Flag'].mean() * 100
print(contract_churn)


#ChurnByTenureGroup
tenure_churn = Df.groupby('tenure_group')['Churn_Flag'].mean() * 100
print(tenure_churn)


#ChurnByServiceAnalysis 
service_cols = [
    'PhoneService',
    'MultipleLines',
    'OnlineSecurity',
    'OnlineBackup',
    'DeviceProtection',
    'StreamingTV',
    'StreamingMovies',
    'InternetService'
]

for col in service_cols:
    print("\n", col)
    print(Df.groupby(col)['Churn_Flag'].mean() * 100)


#ChurnByPaymentMethod
payment_churn = Df.groupby('PaymentMethod')['Churn_Flag'].mean() * 100
print(payment_churn)

#TechSupportImpact
tech_churn = Df.groupby('TechSupport')['Churn_Flag'].mean() * 100
print(tech_churn)


#CUSTOMERANALYSIS
print(Df.groupby('gender')['Churn_Flag'].mean() * 100)
print(Df.groupby('Partner')['Churn_Flag'].mean() * 100)
print(Df.groupby('Dependents')['Churn_Flag'].mean() * 100)
#SeniorCitizensChurn
senior_citizenChurn = Df.groupby('SeniorCitizen')['Churn_Flag'].mean() * 100
print(senior_citizenChurn)

#ranak
factors = [
    'Contract',
    'tenure_group',
    'InternetService',
    'PaymentMethod',
    'TechSupport',
    'SeniorCitizen',
    'gender',
    'Partner',
    'Dependents',
    'OnlineSecurity',
    'OnlineBackup',
    'DeviceProtection',
    'StreamingTV',
    'StreamingMovies',
    'PaperlessBilling'
]
def rank_churn_driver(column):

    churn_rates = Df.groupby(column)['Churn_Flag'].mean() * 100

    highest_rate = churn_rates.max()
    lowest_rate = churn_rates.min()

    churn_gap = highest_rate - lowest_rate

    return {
        'Factor': column,
        'Highest Churn Rate (%)': round(highest_rate, 2),
        'Lowest Churn Rate (%)': round(lowest_rate, 2),
        'Churn Gap (%)': round(churn_gap, 2)
    }
driver_results = []

for factor in factors:
    driver_results.append(rank_churn_driver(factor))

driver_df = pd.DataFrame(driver_results)

driver_df = driver_df.sort_values(
    by='Churn Gap (%)',
    ascending=False
)

print(driver_df)


#graph


# Sort again just to be safe
driver_df = driver_df.sort_values(
    by='Churn Gap (%)',
    ascending=True
)

plt.figure(figsize=(10,7))

plt.barh(
    driver_df['Factor'],
    driver_df['Churn Gap (%)']
)

plt.title('Ranked Churn Drivers')
plt.xlabel('Churn Gap (%)')
plt.ylabel('Factor')

plt.show()

Df.to_csv("clean_telco_churn.csv", index=False)
