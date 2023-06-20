# github workflow actions (to run codes in github website):
```
.github/workflows/welcome.yml		     
```
 # In workflow:
 ```
name: displaying message welcome
on: push
jobs: 
       my-jobs:
	runs-on:
	steps:
	   - name: step1
	      run: echo “welcome to Github Runner”
	  - name: step2
	      run: echo “Bye from Github Runner”
	   - name: step3
	      run: echo “Github is  very powerful tool ”
	   - name: step4
	      run: echo “Github is  used to store and process”
```
