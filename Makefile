# Need to update to terraform v0.10.x to use -check-variable
validate:
	find . -type f -name "*.tf" -exec dirname {} \;|sort -u | while read m; do (terraform validate -check-variables=false "$m" && echo "√ $m") || exit 1 ; done

# https://www.terraform.io/docs/commands/fmt.html 
fmt:
	if [[ -n "$(terraform fmt -write=false)" ]]; then echo "Some terraform files need be formatted, run 'terraform fmt' to fix"; fi

# https://github.com/wata727/tflint
tflint:
	tflint

test:
	tflint
