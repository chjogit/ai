from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index(no=None):
    if request.method == 'POST':
        no = request.form.get('no').strip()
    return render_template(
        '2_quiz.html',
        no=no
        )

@app.errorhandler(404)
def not_found(error):
    return render_template('page_not_found.html', error=error), 404

if __name__=="__main__":
    app.run(debug=True, port=8090)