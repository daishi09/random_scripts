#! /usr/bin/python
import os

def challenge_calc():
    os.system("clear")
    easy_questions = '162'
    correct_easy= input('How many easy questions were correct? \n')
    medium_questions = '115'
    correct_medium = input('How many medium questions were correct? \n')
    hard_questions = '26'
    correct_hard = input('How many hard questions were correct? \n')
    print(easy_questions + ' ' + 'easy questions')
    print(correct_easy + ' ' + 'easy questions answered correctly')
    print(medium_questions + ' ' + 'medium questions')
    print(correct_medium + ' ' + 'medium questions answered correctly')
    print(hard_questions + ' ' + 'hard questions')
    print(correct_hard + ' ' + 'hard questions answered correctly')
    x = input('Is this information correct? y/n \n')

    if x == 'n':
        os.system("clear")
        main()
    else:
        total = ((float(correct_easy)/float(easy_questions)) * 50) + ((float(correct_medium)/float(medium_questions)) * 20) + ((float(correct_hard)/float(hard_questions)) * 30)
        print(total)

def module_grader():
    print('This will calculate the module grades')

    x = input('How many activities were there? \n')
    x = int(x)
    y = 0

    print(x)
    yn = input('Is this information correct? y/n \n')

    if yn == 'n':
        os.system("clear")
        main()
    else:
        for i in range (1,x+1,1):
            z = input('score:')
            z = float(z)
            y = y + z
        print(y/x)

def section_grader():
    print('This will calculate the section grades')
    final = input('What was the grade on the final?')

    final = float(final)

    x = input('How many modules were there? \n')

    x = int(x)

    y = 0

    print(final)
    print(x)
    yn2 = input('Is this information correct? y/n \n')

    if yn2 == 'n':
        os.system("clear")
        main()
    else:
        for i in range (1,x+1,1):
            z = input('score:')
            z = float(z)
            y = y + z
        module = ((y/x) * .6) + (final * .4)
        print(module)

def network_final():
    print('This will calculate the network final')
    final_points = input('What was the number of points earned on the final? \n')

    final_points = float(final_points)

    print(final_points)
    yn3 = input('Is this information correct? y/n \n')

    if yn3 == 'n':
        os.system("clear")
        main()
    else:
       if 0 <= final_points <= 100:
           final_grade = (.7 * final_points)
           print(final_grade)
       elif 101 <= final_points <= 250:
           final_grade = 70 + (.1 * (final_points - 100))
           print(final_grade)
       elif 251 <= final_points <= 335:
           final_grade = 85 + ((3/17) * (final_points - 250))
           print(final_grade)
       else:
           os.system("clear")
           print("That is not a valid number of points, please try again.")
           main()


def main():
    print('challenge_calc = 1')
    print('This will calculate your grade for CTFd challenges. \n')
    print('module_grader = 2')
    print('This will calculate the module grades. \n')
    print('section_grader = 3')
    print('This will calculate the section grades. \n')
    print('networking_final_grader = 4')
    print('This will calculate the network final grades. \n')

    tool_choice = input('Which tool would you like to use? \n')

    if tool_choice == '1':
        challenge_calc()
    elif tool_choice == '2':
        module_grader()
    elif tool_choice == '3':
        section_grader()
    elif tool_choice == '4':
        network_final()
    else:
        os.system("clear")
        print("That is not an available selection, please try again.")
        main()

main()
