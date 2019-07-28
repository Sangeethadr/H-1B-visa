import numpy
import pandas
from sklearn.tree import DecisionTreeClassifier
from pandas import read_csv
from sklearn.metrics import confusion_matrix
from sklearn.model_selection import train_test_split
filename = "us_perm_visas.csv"
a = read_csv(filename)
array = a.values
a.groupby('country_of_citzenship').size()
X = pandas.get_dummies(array[:,9],array[:,11],array[:,17],dummy_na=False)
Y = array[:,8]
#Z = pandas.get_dummies(array[:,17],dummy_na=False)
test_size = 0.3
seed = 7
X_train, X_test, Y_train, Y_test = train_test_split(X,Y,test_size = test_size,random_state = seed)

model = DecisionTreeClassifier(random_state=5)
model.fit(X_train, Y_train)
predicted = model.predict(X_test)
matrix = confusion_matrix(Y_test,predicted)
print()
print(model.feature_importances_)
model.predict_proba(X)
model.score(X_test,Y_test)

