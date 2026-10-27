from django.shortcuts import render

# text 입력
def wordinput(request):
    return render(request, 'wordcnt/wordinput.html')

def about(request):
    return render(request, 'wordcnt/about.html')

def result(request):
    fulltxt = request.POST.get('fulltxt').strip()
    strlength = len(fulltxt) # 글자 수
    words = fulltxt.split()
    wordcnt = len(words) # 단어 수
    words_dic = dict() # 빈 딕셔너리
    for word in words:
        if word in words_dic.keys(): # word가 words_dic의 key로 존재하는지 여부 확인
            words_dic[word] += 1
        else:
            words_dic[word] = 1
    print(fulltxt, wordcnt)
    context = {
        'fulltxt':fulltxt,
        'strlength':strlength,
        'wordcnt':wordcnt,
        'dict':words_dic.items() # [('hong',2),('good',1),('luck',1)]
    }
    return render(
        request,
        'wordcnt/result.html',
        context=context
        ) 