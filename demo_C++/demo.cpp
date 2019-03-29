#include <iostream>
#include <termios.h>
#include <unistd.h>

using namespace std;

char getch();

int main() {
    bool storage[300] = {};
    storage[250] = 1;
    storage[251] = 1;
    storage[252] = 1;
    bool storage_new[22] = {};

    for (int i = 0; i < 22; i++) {
        cout << (storage_new[i] ? "■" : "□") << " ";
    }
    cout << endl << endl;

    for (int y = 0; y < 15; y++) {
        for (int x = 0; x < 20; x++) {
            cout << (storage[x + y * 20] ? "■" : "□") << " ";
        }
        cout << endl;
    }
    cout << endl << endl;

    while (1) {
        char c = getch();
        if (c == 'j' || c == 'k') {
            // ┏━╸┏━┓┏━╸┏━┓   ┏━┓╺┳╸╻ ╻┏━╸┏━╸ //
            // ┣╸ ┣━┛┃╺┓┣━┫   ┗━┓ ┃ ┃ ┃┣╸ ┣╸  //
            // ╹  ╹  ┗━┛╹ ╹   ┗━┛ ╹ ┗━┛╹  ╹   //
            bool store = storage[299];
            for (int i = 299; i > 0; i = i - 1) {
                storage[i] = storage[i - 1];
            }
            storage[0] = store;

            for (int i = 22; i > 0; i = i - 1) {
                storage_new[i] = storage_new[i-1];
            }
            storage_new[0] = store;
            

            if (c == 'k') {
                for (int i = 0; i < 22; i++) {
                    cout << (storage_new[i] ? "■" : "□") << " ";
                }
                cout << endl << endl;

                for (int y = 0; y < 15; y++) {
                    for (int x = 0; x < 20; x++) {
                        cout << (storage[x + y * 20] ? "■" : "□") << " ";
                    }
                    cout << endl;
                }
                cout << endl << endl;
            }



            storage[0] = ((storage_new[1] + storage_new[19] + storage_new[20] + storage_new[21] + storage[279] + storage[280] + storage[281] + storage[299]) | storage[0]) == 3;


            ////////////////////////////////////
            
            if (c == 'k') getch();
            for (int i = 0; i < 22; i++) {
                cout << (storage_new[i] ? "■" : "□") << " ";
            }
            cout << endl << endl;

            for (int y = 0; y < 15; y++) {
                for (int x = 0; x < 20; x++) {
                    cout << (storage[x + y * 20] ? "■" : "□") << " ";
                }
                cout << endl;
            }
            cout << endl <<  endl;

        } else if (c == 'q') {
            return 0;
        }
    }
}






// yes, this function comes from stackoverflow, I was too lazy to work with ncurses: https://stackoverflow.com/questions/7469139/what-is-the-equivalent-to-getch-getche-in-linux
char getch(){
    char buf=0;
    struct termios old={0};
    fflush(stdout);
    if(tcgetattr(0, &old)<0)
        perror("tcsetattr()");
    old.c_lflag&=~ICANON;
    old.c_lflag&=~ECHO;
    old.c_cc[VMIN]=1;
    old.c_cc[VTIME]=0;
    if(tcsetattr(0, TCSANOW, &old)<0)
        perror("tcsetattr ICANON");
    if(read(0,&buf,1)<0)
        perror("read()");
    old.c_lflag|=ICANON;
    old.c_lflag|=ECHO;
    if(tcsetattr(0, TCSADRAIN, &old)<0)
        perror ("tcsetattr ~ICANON");
    return buf;
 }
