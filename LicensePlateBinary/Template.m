%Alphabets
A=imread('A_template.bmp');B=imread('B_template.bmp');C=imread('C_template.bmp');
D=imread('D_template.bmp');E=imread('E_template.bmp');F=imread('F_template.bmp');
G=imread('G_template.bmp');H=imread('H_template.bmp');I=imread('I_template.bmp');
J=imread('J_template.bmp');K=imread('K_template.bmp');L=imread('L_template.bmp');
M=imread('M_template.bmp');N=imread('N_template.bmp');O=imread('O_template.bmp');
P=imread('P_template.bmp');Q=imread('Q_template.bmp');R=imread('R_template.bmp');
S=imread('S_template.bmp');T=imread('T_template.bmp');U=imread('U_template.bmp');
V=imread('V_template.bmp');W=imread('W_template.bmp');X=imread('X_template.bmp');
Y=imread('Y_template.bmp');Z=imread('Z_template.bmp');

%Natural Numbers
one=imread('1_template.bmp');two=imread('2_template.bmp');
three=imread('3_template.bmp');four=imread('4_template.bmp');
five=imread('5_template.bmp'); six=imread('6_template.bmp');
seven=imread('7_template.bmp');eight=imread('8_template.bmp');
nine=imread('9_template.bmp'); zero=imread('0_template.bmp');

%Array for Alphabets
letter=[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z];

%Array for Numbers
number=[one two three four five six seven eight nine zero];

CharTemplates = [letter number];
% Save Templates
save('CharTemplates', 'CharTemplates');
clear all;