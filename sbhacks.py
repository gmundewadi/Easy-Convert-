import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn import svm
from sklearn import metrics
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


column   = ['label','age','gender','location','scanned_price','currency','purchase']
category = ['appliances','artifact/souvenir','beauty/personal care','electronics','food','health/drugs']
#                  1               2                3                     4          5          6       
#Gender: 1 male 0 female

df = pd.DataFrame(columns=column)

df = df.append({'label': 1, 'age':15, 'gender':1, 'location': 'los angeles', 'scanned_price': 7.99, 'currency':6.8, 'purchase':9}, ignore_index=True)
df = df.append({'label': 1, 'age':33, 'gender':0, 'location': 'los angeles', 'scanned_price': 27.99, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 4, 'age':22, 'gender':0, 'location': 'london', 'scanned_price': 57.99, 'currency':8.7, 'purchase':3}, ignore_index=True)
df = df.append({'label': 3, 'age':45, 'gender':1, 'location': 'new york', 'scanned_price': 24.39, 'currency':6.8, 'purchase':4}, ignore_index=True)
df = df.append({'label': 1, 'age':50, 'gender':0, 'location': 'new york', 'scanned_price': 104.39, 'currency':6.8, 'purchase':1}, ignore_index=True)
df = df.append({'label': 5, 'age':29, 'gender':1, 'location': 'tokyo', 'scanned_price': 2400, 'currency':0.062,'purchase':7}, ignore_index=True)
df = df.append({'label': 4, 'age':15, 'gender':1, 'location': 'los angeles', 'scanned_price': 32, 'currency':6.8, 'purchase':8}, ignore_index=True)
df = df.append({'label': 1, 'age':44, 'gender':0, 'location': 'los angeles', 'scanned_price': 49, 'currency':6.8, 'purchase':5}, ignore_index=True)
df = df.append({'label': 4, 'age':53, 'gender':0, 'location': 'london', 'scanned_price': 14, 'currency':8.7, 'purchase':8}, ignore_index=True)
df = df.append({'label': 3, 'age':17, 'gender':0, 'location': 'new york', 'scanned_price': 19, 'currency':6.8, 'purchase':10}, ignore_index=True)
df = df.append({'label': 2, 'age':50, 'gender':0, 'location': 'new york', 'scanned_price': 100, 'currency':6.8, 'purchase':2}, ignore_index=True)
df = df.append({'label': 6, 'age':29, 'gender':1, 'location': 'tokyo', 'scanned_price': 3400, 'currency':0.062,'purchase':5}, ignore_index=True)
df = df.append({'label': 3, 'age':26, 'gender':1, 'location': 'los angeles', 'scanned_price': 7.99, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 2, 'age':36, 'gender':0, 'location': 'los angeles', 'scanned_price': 27.99, 'currency':6.8, 'purchase':6}, ignore_index=True)
df = df.append({'label': 4, 'age':31, 'gender':1, 'location': 'london', 'scanned_price': 32.99, 'currency':8.7, 'purchase':7}, ignore_index=True)
df = df.append({'label': 3, 'age':29, 'gender':1, 'location': 'new york', 'scanned_price': 24.39, 'currency':6.8, 'purchase':5}, ignore_index=True)
df = df.append({'label': 5, 'age':37, 'gender':0, 'location': 'new york', 'scanned_price': 54.39, 'currency':6.8, 'purchase':9}, ignore_index=True)
df = df.append({'label': 4, 'age':19, 'gender':1, 'location': 'tokyo', 'scanned_price': 78400, 'currency':0.062,'purchase':7}, ignore_index=True)
df = df.append({'label': 6, 'age':44, 'gender':0, 'location': 'los angeles', 'scanned_price': 49, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 4, 'age':23, 'gender':1, 'location': 'london', 'scanned_price': 14, 'currency':8.7, 'purchase':8}, ignore_index=True)
df = df.append({'label': 3, 'age':17, 'gender':0, 'location': 'new york', 'scanned_price': 59, 'currency':6.8, 'purchase':10}, ignore_index=True)
df = df.append({'label': 2, 'age':50, 'gender':0, 'location': 'new york', 'scanned_price': 10, 'currency':6.8, 'purchase':9}, ignore_index=True)
df = df.append({'label': 1, 'age':29, 'gender':1, 'location': 'tokyo', 'scanned_price': 3400, 'currency':0.062,'purchase':7}, ignore_index=True)
df = df.append({'label': 3, 'age':26, 'gender':1, 'location': 'los angeles', 'scanned_price': 7.99, 'currency':6.8, 'purchase':6}, ignore_index=True)
df = df.append({'label': 2, 'age':36, 'gender':0, 'location': 'los angeles', 'scanned_price': 27.99, 'currency':6.8, 'purchase':6}, ignore_index=True)
df = df.append({'label': 5, 'age':31, 'gender':1, 'location': 'london', 'scanned_price': 32.99, 'currency':8.7, 'purchase':8}, ignore_index=True)
df = df.append({'label': 6, 'age':29, 'gender':1, 'location': 'new york', 'scanned_price': 24.39, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 5, 'age':37, 'gender':0, 'location': 'new york', 'scanned_price': 54.39, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 3, 'age':19, 'gender':0, 'location': 'tokyo', 'scanned_price': 18400, 'currency':0.062,'purchase':6}, ignore_index=True)
df = df.append({'label': 4, 'age':49, 'gender':1, 'location': 'seattle', 'scanned_price': 999, 'currency':6.8,'purchase':7}, ignore_index=True)
df = df.append({'label': 5, 'age':41, 'gender':0, 'location': 'los angeles', 'scanned_price': 70, 'currency':6.8,'purchase':6}, ignore_index=True)
df = df.append({'label': 3, 'age':24, 'gender':1, 'location': 'london', 'scanned_price': 59, 'currency':8.7,'purchase':3}, ignore_index=True)
df = df.append({'label': 2, 'age':14, 'gender':0, 'location': 'paris', 'scanned_price': 11, 'currency':7.8,'purchase':7}, ignore_index=True)
df = df.append({'label': 6, 'age':32, 'gender':1, 'location': 'berlin', 'scanned_price': 200, 'currency':7.8,'purchase':1}, ignore_index=True)
df = df.append({'label': 1, 'age':28, 'gender':1, 'location': 'tokyo', 'scanned_price':8100 , 'currency':0.062,'purchase':6}, ignore_index=True)
df = df.append({'label': 1, 'age':15, 'gender':1, 'location': 'los angeles', 'scanned_price': 7.99, 'currency':6.8, 'purchase':9}, ignore_index=True)
df = df.append({'label': 2, 'age':22, 'gender':1, 'location': 'new york', 'scanned_price': 12.50, 'currency':6.8, 'purchase':8}, ignore_index=True)
df = df.append({'label': 5, 'age':30, 'gender':0, 'location': 'beijing', 'scanned_price': 30.00, 'currency':1, 'purchase':7}, ignore_index=True)
df = df.append({'label': 3, 'age':18, 'gender':1, 'location': 'tokyo', 'scanned_price': 1600.00, 'currency':0.06, 'purchase':8}, ignore_index=True)
df = df.append({'label': 4, 'age':55, 'gender':0, 'location': 'shanghai', 'scanned_price': 69.99, 'currency':1, 'purchase':6}, ignore_index=True)
df = df.append({'label': 6, 'age':42, 'gender':0, 'location': 'london', 'scanned_price': 6.00, 'currency':7.9, 'purchase':8}, ignore_index=True)
df = df.append({'label': 5, 'age':26, 'gender':0, 'location': 'paris', 'scanned_price': 14.99, 'currency':7.9, 'purchase':5}, ignore_index=True)
df = df.append({'label': 4, 'age':35, 'gender':1, 'location': 'osaka', 'scanned_price': 2499.00, 'currency':0.06, 'purchase':9}, ignore_index=True)
df = df.append({'label': 2, 'age':61, 'gender':1, 'location': 'san francisco', 'scanned_price': 23.00, 'currency':6.8, 'purchase':6}, ignore_index=True)
df = df.append({'label': 1, 'age':13, 'gender':0, 'location': 'seattle', 'scanned_price': 52.00, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 4, 'age':23, 'gender':1, 'location': 'boston', 'scanned_price': 20.00, 'currency':6.8, 'purchase':8}, ignore_index=True)
df = df.append({'label': 2, 'age':27, 'gender':0, 'location': 'los angeles', 'scanned_price': 18, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 3, 'age':30, 'gender':1, 'location': 'tokyo', 'scanned_price': 3000, 'currency':0.06, 'purchase':2}, ignore_index=True)
df = df.append({'label': 1, 'age':44, 'gender':0, 'location': 'london', 'scanned_price': 70, 'currency':8.7, 'purchase':5}, ignore_index=True)
df = df.append({'label': 6, 'age':34, 'gender':1, 'location': 'tokyo', 'scanned_price': 4400.00, 'currency':0.06, 'purchase':9}, ignore_index=True)
df = df.append({'label': 2, 'age':59, 'gender':0, 'location': 'london', 'scanned_price': 46.00, 'currency':7.9, 'purchase':1}, ignore_index=True)
df = df.append({'label': 1, 'age':24, 'gender':0, 'location': 'paris', 'scanned_price': 14.99, 'currency':7.9, 'purchase':6}, ignore_index=True)
df = df.append({'label': 4, 'age':38, 'gender':1, 'location': 'osaka', 'scanned_price': 9999.00, 'currency':0.06, 'purchase':9}, ignore_index=True)
df = df.append({'label': 6, 'age':44, 'gender':1, 'location': 'san francisco', 'scanned_price': 23.00, 'currency':6.8, 'purchase':7}, ignore_index=True)
df = df.append({'label': 3, 'age':19, 'gender':0, 'location': 'seattle', 'scanned_price': 70.00, 'currency':6.8, 'purchase':9}, ignore_index=True)
df = df.append({'label': 5, 'age':28, 'gender':1, 'location': 'london', 'scanned_price': 30.00, 'currency':7.9, 'purchase':8}, ignore_index=True)

def histogram(label):
    label_df   = df.loc[df['label'] == label]  #label_df is a numpy array
    all_prices = label_df['scanned_price'].values
    plt.hist(all_prices, bins=np.arange(min(all_prices), max(all_prices) + 10, 10))
    plt.show()

l = df['label'].values
l = l.astype('int')
y = df['purchase'].values
y = y.astype('int')
X = df.drop(['purchase','location'], axis=1).values

X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=0.25,random_state=42)

neighbors = np.arange(1, 9)
train_accuracy = np.empty(len(neighbors))
test_accuracy = np.empty(len(neighbors))

# Loop over different values of k
for i, k in enumerate(neighbors):
    # Setup a k-NN Classifier with k neighbors: knn
    knn = KNeighborsClassifier(n_neighbors=k)
    # Fit the classifier to the training data
    knn.fit(X_train,y_train)
    #Compute accuracy on the training set
    train_accuracy[i] = knn.score(X_train, y_train)
    #Compute accuracy on the testing set
    test_accuracy[i] = knn.score(X_test, y_test)

# Generate plot
plt.title('k-NN: Varying Number of Neighbors')
plt.plot(neighbors, test_accuracy, label = 'Testing Accuracy')
plt.plot(neighbors, train_accuracy, label = 'Training Accuracy')
plt.legend()
plt.xlabel('Number of Neighbors')
plt.ylabel('Accuracy')
plt.show()


knn = KNeighborsClassifier(n_neighbors=6)
knn.fit(X_train,y_train)

y_pred = knn.predict(X_test)

test = pd.DataFrame()
test = test.append({'label': 4, 'age':24, 'gender':1, 'scanned_price': 20, 'currency':6.8}, ignore_index=True)
print("*********Prediction for test observation is", knn.predict(test))

print("Purchase Index predictions:\n {}".format(y_pred))
print("The accuracy for the purchase index prediction is", knn.score(X_test,y_test))

######################################### Label Predictions #######################################################

X_new = df.drop(['label','location'], axis=1).values

X_new_train, X_new_test, l_train, l_test = train_test_split(X_new,l,test_size=0.25,random_state=21)

neighbors = np.arange(1, 9)
train_accuracy = np.empty(len(neighbors))
test_accuracy = np.empty(len(neighbors))

# Loop over different values of k
for i, k in enumerate(neighbors):
    # Setup a k-NN Classifier with k neighbors: knn
    knn = KNeighborsClassifier(n_neighbors=k)
    # Fit the classifier to the training data
    knn.fit(X_new_train,l_train)
    #Compute accuracy on the training set
    train_accuracy[i] = knn.score(X_new_train, l_train)
    #Compute accuracy on the testing set
    test_accuracy[i] = knn.score(X_new_test, l_test)

# Generate plot
plt.title('k-NN: Varying Number of Neighbors')
plt.plot(neighbors, test_accuracy, label = 'Testing Accuracy')
plt.plot(neighbors, train_accuracy, label = 'Training Accuracy')
plt.legend()
plt.xlabel('Number of Neighbors')
plt.ylabel('Accuracy')
plt.show()

knnlab = KNeighborsClassifier(n_neighbors=5)
knnlab.fit(X_new_train,l_train)

l_pred = knnlab.predict(X_new_test)

print("Label predictions:\n {}".format(l_pred))
print("The accuracy for the label prediction is", knnlab.score(X_new_test,l_test))

clf = svm.SVC(kernel='rbf')

#Train the model using the training sets
clf.fit(X_train, y_train)

#Predict the response for test dataset
y_pred = clf.predict(X_test)
print("SVM Accuracy for purchase:",metrics.accuracy_score(y_test, y_pred))

clflab = svm.SVC(kernel='rbf')
clflab.fit(X_new_train,l_train)
l_pred = clflab.predict(X_new_test)
print("SVM Accuracy for label:",metrics.accuracy_score(l_test, l_pred))
