#/bin/sh
#FOLDER=`pwd` (Use this option when you are using terroform in current folder)
FOLDER="/usr/local/bin"

while true; do
    echo " "
    echo "Choose option wisely"
    echo "   all: To run all three terraform commands(Run this setting up first time)"
    echo "   1: To run terraform init command"
    echo "   2: To run terraform plan command"
    echo "   3: To run terraform apply command"
    echo "   4: To Destroy resource"
    echo "   5: To refresh terraform state"
    echo "   6: Show the instance details"
    echo "   N: Exit from script"
    echo " "
read -p "Select your option from above list: " l

    case $l in
        [all]* )
               $FOLDER/terraform init;
               $FOLDER/terraform plan;
               $FOLDER/terraform apply; break;;

        [1]* ) $FOLDER/terraform init; break;;

        [2]* ) $FOLDER/terraform plan; break;;

        [3]* ) $FOLDER/terraform apply; break;;

        [4]* ) read -p "Please enter the target instance to Destroy: " i
               $FOLDER/terraform destroy -target $i; break;;

        [5]* ) $FOLDER/terraform refresh; break;;
        [6]* ) $FOLDER/terraform show; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
#/home/build/kp369d/Terraform/terraform init

#/home/build/kp369d/Terraform/terraform plan

#/home/build/kp369d/Terraform/terraform apply
