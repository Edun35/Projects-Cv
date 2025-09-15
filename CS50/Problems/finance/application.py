import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True


# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    # user id
    user = session["user_id"]
    # lists
    assets = db.execute("SELECT symbol, name, price, SUM(shares) AS tshares FROM trades WHERE user_id=? GROUP BY symbol", user)
    money = db.execute("SELECT cash FROM users WHERE id=?", user)[0]["cash"]
    # total
    total = money
    for asset in assets:
        total += asset["price"] * asset["tshares"]
    # render
    return render_template("index.html", assets=assets, money=money, total=total)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        user = session["user_id"]
        sym = request.form.get("symbol").upper()
        item = lookup(sym)

        # no or invalid symbol
        if not sym:
            return apology("Enter Symbol", 400)
        elif item is None:
            return apology("Invalid Symbol", 400)
        else:

            try:
                shares = int(request.form.get("shares"))
            except:
                return apology("Shares must be an integer", 400)
            # no shares
            if not shares:
                return apology("Enter Shares", 400)
            elif shares <= 0:
                return apology("Shares must be positive", 400)

            money = db.execute("SELECT cash FROM users WHERE id=?", user)[0]['cash']
            item_name = item["name"]
            item_symbol = item["symbol"]
            item_price = item["price"]
            total = item_price * shares

            # not enogh money
            if total > money:
                return apology("Not enough money", 400)
            else:
                # take money
                db.execute("UPDATE users SET cash=? WHERE id=?", money-total, user)
                # update trade table
                db.execute("INSERT INTO trades (user_id, symbol, name, price, shares, type) VALUES (?, ?, ?, ?, ?, ?)",
                           session["user_id"], item_symbol, item_name, item_price, shares, "buy")

                # back to index
                return redirect("/")

    # GET form
    return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    # user id
    user = session["user_id"]
    # lists
    assets = db.execute("SELECT symbol, name, price, shares, type, time FROM trades WHERE user_id=? ORDER BY id DESC", user)
    # render
    return render_template("history.html", assets=assets)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 400)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 400)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 400)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure symbol was submitted
        if not request.form.get("symbol"):
            return apology("must provide symbol", 400)

        else:
            # search IEX for symbol
            sym = lookup(request.form.get("symbol").upper())

            # Invalid symbol
            if sym is None:
                return apology("Invalid symbol", 400)

            # if symbol exists
            return render_template("quoted.html", sym=sym)

    # GET form
    return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 400)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 400)

        # Ensure confirmation was submitted
        if not request.form.get("confirmation"):
            return apology("must confirm password", 400)

        # Ensure confirmation and password are same
        elif request.form.get("confirmation") != request.form.get("password"):
            return apology("password not equal to confirmation", 400)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username not taken
        if len(rows) != 0:
            return apology("username taken", 400)

        # Hash password
        hash = generate_password_hash(request.form.get("password"))

        # add hash and username to database
        db.execute("INSERT INTO users (username, hash) VALUES(?, ?)", request.form.get("username"), hash)

        # to login
        return redirect("/login")

    else:
        # to login page
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    user = session["user_id"]

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure shares
        if not request.form.get("shares"):
            return apology("must provide shares", 400)
        # Ensure shares positive
        elif int(request.form.get("shares")) < 1:
            return apology("Shares must be positive", 400)
        else:
            sym = request.form.get("symbol")
            selling = int(request.form.get("shares"))
            owned = db.execute("SELECT SUM(shares) FROM trades WHERE user_id=? AND symbol=?", user, sym)[0]['SUM(shares)']
            money = db.execute("SELECT cash FROM users WHERE id=?", user)[0]['cash']
            stock = lookup(sym)
            price = stock["price"]
            total = price * selling
            # Ensure shares not greater than owned shares
            if selling > owned:
                return apology("Not enough owned shares", 400)
            else:
                # add money
                db.execute("UPDATE users SET cash=? WHERE id=?", money+total, user)
                # update trade table
                db.execute("INSERT INTO trades (user_id, symbol, name, price, shares, type) VALUES (?, ?, ?, ?, ?, ?)",
                           session["user_id"], sym, stock["name"], price, -selling, "sell")

                # back to index
                return redirect("/")

    else:
        # Get route
        assets = db.execute("SELECT symbol FROM trades WHERE user_id=? GROUP BY symbol", user)
        return render_template("sell.html", assets=assets)


def errorhandler(e):
    """Handle error"""
    if not isinstance(e, HTTPException):
        e = InternalServerError()
    return apology(e.name, e.code)


# Listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)


@app.route("/change", methods=["GET", "POST"])
@login_required
def change():

    user = session["user_id"]

    if request.method == "POST":

        if not request.form.get("old"):
            return apology("must enter old password", 400)
        elif not request.form.get("new"):
            return apology("must enter new password", 400)
        elif not request.form.get("confirmation"):
            return apology("must confirm new password", 400)

        rows = db.execute("SELECT * FROM users WHERE id = ?", user)
        if not check_password_hash(rows[0]["hash"], request.form.get("old")):
            return apology("old password must match", 400)
        elif request.form.get("confirmation") != request.form.get("new"):
            return apology("new password not equal to confirmation", 400)

        # Hash password
        hash = generate_password_hash(request.form.get("new"))

        # add hash and username to database
        db.execute("UPDATE users SET hash=? WHERE id=?", hash, user)

        # to login
        return redirect("/")
    else:
        return render_template("change.html")