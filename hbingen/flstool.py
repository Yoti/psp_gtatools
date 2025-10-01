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

binHashesNiLcsWw = [
    ['fcd32501', 'HEAD.AT3'],
    ['fc242501', 'DOUBLE.AT3'],
    ['1cf13d01', 'KJAH.AT3'],
    ['2c78d301', 'RISE.AT3'],
    ['0cf63401', 'LIPS.AT3'],
    ['ac037301', 'MUNDO.AT3'],
    ['6c78ac01', 'MSX.AT3'],
    ['7cbc3f01', 'FLASH.AT3'],
    ['7c7f0d02', 'LCJ.AT3'],
    ['0cc82a02', 'LCFR.AT3'],
]

binHashesNiVcsEu = [
    ['c8d5cb02', 'FLASH.AT3'],
    ['b8dd9202', 'VROCK.AT3'],
    ['78dfc701', 'PARADISE.AT3'],
    ['a88fcd02', 'VCPR.AT3'],
    ['489dad01', 'VCFL.AT3'],
    ['682a6e02', 'WAVE_EU.AT3'],
    ['685b4801', 'FRESH.AT3'],
    ['d8145101', 'ESPANT.AT3'],
    ['5807fb02', 'EMOTION.AT3'],
    ['582c4a00', 'CITY.AT3'],
]

binHashesNiVcsUs = [
    ['c8d5cb02', 'FLASH.AT3'],
    ['b8dd9202', 'VROCK.AT3'],
    ['78dfc701', 'PARADISE.AT3'],
    ['a88fcd02', 'VCPR.AT3'],
    ['489dad01', 'VCFL.AT3'],
    ['f8629602', 'WAVE_AM.AT3'],
    ['685b4801', 'FRESH.AT3'],
    ['d8145101', 'ESPANT.AT3'],
    ['5807fb02', 'EMOTION.AT3'],
    ['582c4a00', 'CITY.AT3'],
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
isFullScan = False
if os.path.exists(f'{os.path.splitext(sys.argv[0])[0]}.debug'):
    isFullScan = True

def proceedFiles(inPath):
    headers = []

    if headerName == '':
        print("Headers list can't be empty!")
        sys.exit()

    items = glob.glob(os.path.join(inPath, '*.AT3'))
    if isFullScan:
        print('[!] Checking AT3 files...')
    for item in items:
        with open(item, 'rb') as f:
            data = f.read(compareLen)
            headers.append([os.path.basename(item), data])
            if isFullScan:
                print(data[:16].hex(), data[4:8].hex(), os.path.basename(item))
            #else:
                #print(data[4:8].hex(), os.path.basename(item))

    if isFullScan:
        print('[!] Comparing AT3 files...')
    idx = 0
    for headerItem in headerItems:
        at3Name = '????????.AT3'
        for header in headers:
            if headerItem == header[1]:
                at3Name = header[0]
                at3data = header[1]
        if not at3Name == '????????.AT3':
            if isFullScan:
                print(at3data[:16].hex(), at3data[4:8].hex(), at3Name)
            else:
                print(at3data[4:8].hex(), at3Name)
        else:
            if isFullScan:
                print('deadbeefdeadbeefdeadbeefdeadbeef', 'deadbeef', at3Name)
            else:
                if headerName == 'AT3HEADERS.BIN':
                    print(f'deadbeef {at3Name} -> {binHashesNiLcsWw[idx][1]}')
                elif headerName == 'AT3HEDEU.BIN':
                    print(f'deadbeef {at3Name} -> {binHashesNiVcsEu[idx][1]}')
                elif headerName == 'AT3HEDAM.BIN':
                    print(f'deadbeef {at3Name} -> {binHashesNiVcsUs[idx][1]}')
                else:
                    print(f'deadbeef {at3Name}')
        idx += 1

headerName = ''
headerItems = []
def proceedHeader(inPath):
    global headerName
    global headerItems
    headerItems = []

    with open(inPath, 'rb') as headerFile:
        headerData = headerFile.read()

    if len(headerData) % headerSize == 0:
        headerName = os.path.basename(inPath)
        print(f'{headerName} ({len(headerData)})')
        if isFullScan:
            print('[!] Parsing BIN file...')
        for i in range(0, len(headerData) // headerSize):
            headerPart = headerData[headerSize*i:headerSize*i+compareLen]
            headerItems.append(headerPart)
            if isFullScan:
                print(headerPart[:16].hex(), headerPart[4:8].hex(), '????????.AT3')

def proceedDir(inPath):
    items = glob.glob(os.path.join(inPath, '*'))
    for item in items:
        if item.endswith(('PSP_GAME', 'USRDIR', 'AUDIO')):
            proceedDir(item)
        if item.endswith(('AT3HEADERS.BIN', 'AT3HEDEU.BIN', 'AT3HEDAM.BIN')):
            proceedHeader(item)
        if item.endswith('MUSIC'):
            proceedFiles(item)

if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('flstool v20251001 by Yoti')
        print(f'usage: python3 {os.path.basename(sys.argv[0])} <dir(s)>')
        sys.exit()

    if compareLen < 6 or compareLen > headerSize:
        print(f'Wrong compareLen value ({compareLen})')

    for arg in range(1, len(sys.argv)):
        exists = os.path.exists(sys.argv[arg])
        isFile = os.path.isfile(sys.argv[arg])
        if exists and not isFile:
            print('[', os.path.basename(sys.argv[arg]), ']')
            proceedDir(sys.argv[arg])
        else:
            print(f'Wrong argument {sys.argv[arg]}')
