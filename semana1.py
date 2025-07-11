from flask import Flask, request,jsonify
import json



valid_states= ["To do", "In progress...", "Completed!!"]

app=Flask(__name__)

@app.route("/")
def init():
    return "Hello Lyfter Team"



@app.route("/tasks")
def get_task():
    try:
        with open("tasks.json", "r") as file:
            tasks = json.load(file)
        filter_state= request.args.get("state")
        if filter_state:
            filters_tasks = []
            for task in tasks:
                if task.get("state", " ").lower()==filter_state.lower():
                    filters_tasks.append(task)


            return jsonify({
                "message": f"Filters tasks from state:{filter_state}",
                "tasks": filters_tasks,
                "total": len(filters_tasks)
            })
        

        return jsonify({
            "message":"All tasks get successfully",
            "tasks": tasks,
            "total":len(tasks)

        })
    

    except FileNotFoundError:
        return jsonify({
            "message": "Not find the task file",
            "tasks": [],
            "total":0
        }),400
    


@app.route("/tasks", methods= ["POST"])
def create_task():
    new_task_data=request.get_json()
    if not new_task_data:
        return jsonify({'error': 'Not file JSON received'}), 400
            

    task_id= new_task_data.get("id")
    title= new_task_data.get("title")
    description=new_task_data.get("description")
    state= new_task_data.get("state")


    if not task_id or not title or not description or not state:
        return jsonify({"error": "Check the last information, some data is missing"})
    

    
    if state not in valid_states:
        return jsonify({"error": f"The state{state} is not valid. Allowed values: {valid_states}"}),400
    

    try:
        with open ("tasks.json", "r") as file:
            tasks=json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        tasks=[]

    for task_item in tasks:
        if task_item.get ("id")== task_id:
            return jsonify({"error": f"Is all ready task exist with this id '{task_id}'."}),409
        

    new_task={
        "id": task_id,
        "title": title,
        "description": description,
        "state": state
    }


    tasks.append(new_task)


    with open ("tasks.json", "w") as file:
        json.dump(tasks,file, indent=4)



    return jsonify({
        "message": "Task created successfully",
        "task": new_task
    }),201


@app.route("/tasks/<int:task_id>", methods= ["PUT"])
def update_task(task_id):
    update_data= request.get_json()
    if not update_data:
        return jsonify({"Error": "Not have any data to update. "}),400
    if "state" in update_data:
        valid_states= ["To do", "In progress...", "Completed!!"]
        if update_data["state"] not in valid_states:
            return jsonify({"error":f"The state '{update_data['state']}' is not valid"}),400


    try:
        with open("tasks.json", "r") as file:
            tasks = json.load(file)
    except(FileNotFoundError, json.JSONDecodeError):
            return jsonify({"error": "Not found tasks"}),404
    

    task_to_update= None
    for task in tasks:
            if task.get("id") == task_id:
                task_to_update= task
                break


    if not task_to_update:
            return jsonify({"error": f"task with id {task_id} not found"}),404


    task_to_update.update(update_data)


    
    with open ("tasks.json","w") as file:
        json.dump(tasks, file, indent=4)


    return jsonify({
        "message": "Task update successfully",
        "task": task_to_update
    })


@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    try:
        with open("tasks.json","r") as file:
            tasks=json.load(file)
    except(FileNotFoundError, json.JSONDecodeError):
        return jsonify({"error":"Task file not found"}), 404
    

    task_to_delete=None
    for task in tasks:
        if task.get("id") == task_id:
            task_to_delete = task
            break


    if not task_to_delete:
        return jsonify({"error":f"The task with {task_id} was no found"}),404
    
    tasks.remove(task_to_delete)



    with open ("tasks.json", "w") as file:
        json.dump(tasks, file, indent=4)


    return jsonify({"message": f"Tasks with the id {task_id} has been deleted successfully. "})




if __name__ == "__main__":
    print("Initializing the API´s tasks....")
    print("Available Endpoints")
    print("GET/TASKS...")
    print("GET/tasks?estate=<state_name>")
    app.run(debug=True)
    

