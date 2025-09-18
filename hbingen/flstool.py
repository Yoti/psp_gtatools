# -*- coding: utf-8 -*-
#!/usr/bin/env python3

import os
import sys
import glob

isoHashesNoIntro = [
    ['9341cf2fb09dcee24c24d3830519bed6', 'Grand Theft Auto - Liberty City Stories (Europe) (v1.00).iso'],
    ['920642b8299f1655b23d638ce4ea6b56', 'Grand Theft Auto - Liberty City Stories (Europe) (v4.00).iso'],
    ['e6c1b891dd946d1c58157f281a23d2ed', 'Grand Theft Auto - Liberty City Stories (Germany).iso'],
    ['c69f7c609038f5938fab4087e249cdfe', 'Grand Theft Auto - Liberty City Stories (USA) (v1.01).iso'],
    ['0f53919cb8d2f1944b416ffdc597369c', 'Grand Theft Auto - Liberty City Stories (USA) (v4.00).iso'],
    ['669783f1c7d3966385782ade672d2b98', 'Grand Theft Auto - Vice City Stories (Europe).iso'],
    ['8fdf7aa9bcbf0961750724781cc2a2c0', 'Grand Theft Auto - Vice City Stories (Germany).iso'],
    ['5b6b0ed024eaea63511a387efd6b9595', 'Grand Theft Auto - Vice City Stories (USA).iso'],
]

isoHashesRedump = [
	['17cd20ebfae0c1d992a74f91234c96e6', 'Grand Theft Auto - Liberty City Stories (Europe) (En,Fr,De,Es,It) (v1.05).iso'],
	['04c3e22762121ca59e8d6b83a0855211', 'Grand Theft Auto - Liberty City Stories (Europe) (En,Fr,De,Es,It) (v2.00).iso'],
	['cf40e781475451db431769f9ea0f7998', 'Grand Theft Auto - Liberty City Stories (Europe) (En,Fr,De,Es,It) (v3.00).iso'],
	['6ac9ad3b95e5ef96068d101c1b991bd7', 'Grand Theft Auto - Liberty City Stories (Germany) (v1.00).iso'],
	['cf7947456ea763ecf8e330ad428a7f3d', 'Grand Theft Auto - Liberty City Stories (Germany) (v2.00).iso'],
	['6deeae920efd43ca6967a8c6914be585', 'Grand Theft Auto - Liberty City Stories (Japan) (Rockstar Classics).iso'],
	['00f1215e94c7a607d2d9d0ab3c1eeaaf', 'Grand Theft Auto - Liberty City Stories (Japan).iso'],
	['c2733274c523d33431b1320ef516a1ee', 'Grand Theft Auto - Liberty City Stories (Korea) (En,Fr,De,Es,It).iso'],
	['d08daddc86356f2cf5fdfa85cdcd0c91', 'Grand Theft Auto - Liberty City Stories (USA) (En,Fr,De,Es,It) (v1.05).iso'],
	['7230bf9f55d89a34913f817b6e8a4fc4', 'Grand Theft Auto - Liberty City Stories (USA) (En,Fr,De,Es,It) (v3.00).iso'],
	['bf17f0cabd2f3d9ba3c30413c070758e', 'Grand Theft Auto - Vice City Stories (Europe) (En,Fr,De,Es,It).iso'],
	['ac8e2753bf955be62eb6338780b8367b', 'Grand Theft Auto - Vice City Stories (Germany).iso'],
	['b5f6418d0ad7d1646a8cc67c56b805bd', 'Grand Theft Auto - Vice City Stories (Japan) (Rockstar Classics).iso'],
	['6f2717cc3ced3a3646582533a3ce3ddc', 'Grand Theft Auto - Vice City Stories (Japan).iso'],
	['f3734cd9ef8fa3f8daf07d0550481092', 'Grand Theft Auto - Vice City Stories (USA).iso'],
]

headerSize = 2048
compareLen = 2048

def proceedFiles(inPath):
    if headerName == '':
        print("Headers list can't be empty!")
        sys.exit()

    items = glob.glob(os.path.join(inPath, '*.AT3'))
    headers = []
    for item in items:
        with open(item, 'rb') as f:
            data = f.read(compareLen)
            headers.append([os.path.basename(item), data])

    for headerItem in headerItems:
        at3Name = '_NOTFOUND_'
        for header in headers:
            if headerItem == header[1]:
                at3Name = header[0]
        print(at3Name)

headerName = ''
headerItems = []
def proceedHeader(inPath):
    global headerName
    global headerItems

    with open(inPath, 'rb') as headerFile:
        headerData = headerFile.read()

    if len(headerData) % headerSize == 0:
        headerName = os.path.basename(inPath)
        print(f'{headerName} [{len(headerData)}]')
        for i in range(0, len(headerData) // headerSize):
            headerItems.append(headerData[headerSize*i:headerSize*i+compareLen])

def proceedDir(inPath):
    items = glob.glob(os.path.join(inPath, '*'))
    for item in items:
        if item.endswith(('PSP_GAME', 'USRDIR', 'AUDIO')):
            proceedDir(item)
        if item.endswith(('AT3HEADERS.BIN', 'AT3HEDEU.BIN', 'AT3HEDAM.BIN')):
            proceedHeader(item)
        if item.endswith('MUSIC'):
            proceedFiles(item)

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print('flstool v20250918 by Yoti')
        print(f'usage: python3 {os.path.basename(sys.argv[0])} <dir(s)>')
        sys.exit()

    if compareLen < 6 or compareLen > headerSize:
        print(f'Wrong compareLen value ({compareLen})')

    for arg in range(1, len(sys.argv)):
        exists = os.path.exists(sys.argv[arg])
        isFile = os.path.isfile(sys.argv[arg])
        if exists and not isFile:
            print(os.path.basename(sys.argv[arg]))
            proceedDir(sys.argv[arg])
        else:
            print(f'Wrong argument {sys.argv[arg]}')
